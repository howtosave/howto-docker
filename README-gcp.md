# Google Cloud Platform

## [Configuration](https://cloud.google.com/sdk/gcloud/reference/topic/configurations)

```sh
# set default config
gcloud init
# or create a new config
# config file location: ~/.config/gcloud/configurations/config_howto-docker
gcloud config configurations create howto-docker

# activate a config
gcloud config configurations activate howto-docker
# or set env variable
CLOUDSDK_ACTIVE_CONFIG_NAME=howto-docker

# set config values
gcloud config set core/account id@gmail.com
...
```

- config file example

```txt
[core]
account = id@gmail.com
project = howto-carbon

[compute]
zone = asia-northeast3-c
region = asia-northeast3
```

## Access Cloud Console

- using [gcloud beta command](https://cloud.google.com/sdk/gcloud/reference/beta)

```sh
gcloud beta cloud-shell ssh
```

- using cloud-shell on [cloud console](https://console.cloud.google.com/)

## Create volume in Google Compute

- name: standard-persistent-disk-500gb
- cloud console: https://console.cloud.google.com/compute/disks

```sh
# create disk
# for disk type see https://cloud.google.com/compute/docs/disks#disk-types
gcloud beta compute disks create standard-persistent-disk-500gb \
  --project="$PROJECT_ID" \
  --type=pd-standard \
  --size=500GB \
  --zone=asia-northeast3-c \
  --labels=env=all,type=volume

# describe disk
gcloud compute disks describe standard-persistent-disk-500gb

# attach disk to an instance
gcloud compute instances attach-disk instance-group-nodejs-dev \
  --disk standard-persistent-disk-500gb
```

## Create instance-template for nodejs-dev instance

- COS(container-optimized OS) instance template for maintainence
- name: instance-template-nodejs-dev
- container image: marketplace.gcr.io/google/nodejs
- cloud console: https://console.cloud.google.com/compute/instanceTemplates

```sh
PROJECT_ID="howto-docker"
SERVICE_ACCOUNT_ID="my-compute"

# create instance template
gcloud beta compute --project="$PROJECT_ID" instance-templates create-with-container instance-template-nodejs-dev --machine-type=e2-micro --subnet="projects/$PROJECT_ID/regions/asia-northeast3/subnetworks/default" --network-tier=STANDARD --metadata=google-logging-enabled=true --no-restart-on-failure --maintenance-policy=TERMINATE --preemptible --service-account="$SERVICE_ACCOUNT_ID@developer.gserviceaccount.com" --scopes=https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.full_control --region=asia-northeast3 --tags=http-server,https-server --image=cos-stable-85-13310-1041-161 --image-project=cos-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=instance-template-nodejs-dev --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --container-image=marketplace.gcr.io/google/nodejs --container-restart-policy=never --container-command=bash --labels=container-vm=cos-stable-85-13310-1041-161,env=dev --reservation-affinity=any
```

## Create instance group from an instance-template

- name: instance-group-nodejs-dev
- number of instances: 1
- cloud console: https://console.cloud.google.com/compute/instanceGroups

```sh
# create instance group
gcloud compute --project="$PROJECT_ID" instance-groups managed create instance-group-nodejs-dev --base-instance-name=instance-group-nodejs-dev --template=instance-template-nodejs-dev --size=1 --zone=asia-northeast3-c
```

## Initialize permanent disk volume

- destination instance name: instance-group-nodejs-dev-ts2x

```sh
# attach disk to an instance
gcloud compute instances attach-disk instance-group-nodejs-dev-sr3l --disk standard-persistent-disk-500gb
# access via ssh
gcloud beta compute ssh --zone "asia-northeast3-c" "instance-group-nodejs-dev-sr3l" --project "$PROJECT_ID"
# or ssh -i PATH_TO_PRIVATE_KEY USERNAME@EXTERNAL_IP

#
# on the instance terminal
#

# check attached disk
sudo lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda       8:0    0   10G  0 disk
|-sda1    8:1       5.9G  0 part /mnt/stateful_partition
|-sda2    8:2    0   16M  0 part
...
sdb       8:16   0  500G  1 disk

# format disk
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

# mount the disk to a directory
sudo mkdir -p /mnt/disks/standard-persistent-disk-500gb
sudo mount -o discard,defaults /dev/sdb /mnt/disks/standard-persistent-disk-500gb

# verify
sudo lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda       8:0    0   10G  0 disk
|-sda1    8:1       5.9G  0 part /mnt/stateful_partition
...
sdb       8:16   0  500G  1 disk /mnt/disks/standard-persistent-disk-500gb

```

## nginx

### templates

- instance-template-cos-nginx
  - command: nginx
  - arguments: -g "daemon off;"
  - volume mounts
    - /volumes/nginx/etc/nginx:/etc/nginx, read-only
    - /volumes/nginx/var:/var, read-/write
  - Disks
    - Additional disks: standard-persistent-disk-500gb
  - Networking
    - Subnet: default (asia-northeast3, 10.178.0.0/20)

### instance-group

- instance-nginx
  - number of instances: 2
  - autoscaling: false



## Appendices

### Google Cloud REST body

- instance-template-cos-nginx

```json
{
  "creationTimestamp": "2021-01-11T21:33:21.074-08:00",
  "description": "",
  "id": "<project_number>",
  "kind": "compute#instanceTemplate",
  "name": "instance-template-cos-nginx",
  "properties": {
    "confidentialInstanceConfig": {
      "enableConfidentialCompute": false
    },
    "scheduling": {
      "onHostMaintenance": "MIGRATE",
      "automaticRestart": true,
      "preemptible": false
    },
    "tags": {
      "items": [
        "https-server"
      ]
    },
    "disks": [
      {
        "type": "PERSISTENT",
        "deviceName": "instance-template-cos-nginx",
        "autoDelete": true,
        "index": 0.0,
        "boot": true,
        "kind": "compute#attachedDisk",
        "mode": "READ_WRITE",
        "initializeParams": {
          "sourceImage": "projects/cos-cloud/global/images/cos-stable-85-13310-1041-161",
          "diskType": "pd-standard",
          "diskSizeGb": "10"
        }
      }
    ],
    "networkInterfaces": [
      {
        "name": "nic0",
        "network": "projects/<project_id>/global/networks/default",
        "accessConfigs": [
          {
            "name": "External NAT",
            "type": "ONE_TO_ONE_NAT",
            "kind": "compute#accessConfig",
            "networkTier": "PREMIUM"
          }
        ],
        "kind": "compute#networkInterface"
      }
    ],
    "reservationAffinity": {
      "consumeReservationType": "ANY_RESERVATION"
    },
    "canIpForward": false,
    "machineType": "e2-highcpu-2",
    "metadata": {
      "fingerprint": "qs42yziUHoY=",
      "kind": "compute#metadata",
      "items": [
        {
          "value": "spec:\n  containers:\n    - name: instance-template-cos-nginx\n      image: marketplace.gcr.io/google/nginx1\n      command:\n        - nginx\n      args:\n        - '-g \"daemon off;\"'\n      volumeMounts:\n        - name: host-path-0\n          mountPath: /etc/nginx\n          readOnly: true\n        - name: host-path-1\n          mountPath: /var\n          readOnly: false\n      stdin: false\n      tty: false\n  restartPolicy: Always\n  volumes:\n    - name: host-path-0\n      hostPath:\n        path: /volumes/nginx/etc/nginx\n    - name: host-path-1\n      hostPath:\n        path: /volumes/nginx/var\n\n# This container declaration format is not public API and may change without notice. Please\n# use gcloud command-line tool or Google Cloud Console to run Containers on Google Compute Engine.",
          "key": "gce-container-declaration"
        },
        {
          "value": "true",
          "key": "google-logging-enabled"
        }
      ]
    },
    "shieldedVmConfig": {
      "enableSecureBoot": false,
      "enableVtpm": true,
      "enableIntegrityMonitoring": true
    },
    "shieldedInstanceConfig": {
      "enableSecureBoot": false,
      "enableVtpm": true,
      "enableIntegrityMonitoring": true
    },
    "labels": {
      "container-vm": "cos-stable-85-13310-1041-161"
    },
    "serviceAccounts": [
      {
        "email": "<email_id>@developer.gserviceaccount.com",
        "scopes": [
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring.write",
          "https://www.googleapis.com/auth/servicecontrol",
          "https://www.googleapis.com/auth/service.management.readonly",
          "https://www.googleapis.com/auth/trace.append"
        ]
      }
    ],
    "displayDevice": {
      "enableDisplay": false
    }
  },
  "selfLink": "projects/<project_id>/global/instanceTemplates/instance-template-cos-nginx"
}
```

