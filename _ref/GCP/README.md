# Google Cloud Platform

## GKE (Google Kubernetes Engine)

- GKE는 GCE 기반으로 동작한다.
- GKE cluster를 만들면 GCE instance-template가 만들어지고
- 이 instance-template에 해당하는 GCE instances들이 만들어 진다.
- GKE에 docker container를 deployment하면 생성된 GCE instances 상에 동작한다.

### Create a cluster(Clusters)

- cluster를 만들면 GCE instance template가 생성됨

### Create a deployment(Workloads)

### Expose workloads

- 생성된 workload를 'expose'하면 'Service'가 만들어 진다.
- 이 단계에서 port 정보를 입력한다.
