
CREATE DATABASE IF NOT EXISTS howtonest;
CREATE USER IF NOT EXISTS 'nestuser'@'localhost' IDENTIFIED BY 'nest0000';
GRANT ALL PRIVILEGES ON * . * TO 'nestuser'@'localhost';
