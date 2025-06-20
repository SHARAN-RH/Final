1. Create an Ansible Cluster in Docker Container & Kubernetes Pod 
=> Note: Don't use pre-created images
●  Setup Ansible Master and Nodes manually in Docker containers and inside a Kubernetes Pod environment for automation testing.

-> Approach
- - create docker containers using a custom image with ansible
- - use ssh to connect master nodes
- - build inventory manually and use ansible -m ping to test
- - repeat the same setup using Kubernetes pods instead of docker containers
