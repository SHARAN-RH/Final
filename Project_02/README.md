2. Create a Jenkins Cluster in Docker Container & Kubernetes Pod 
=> Note: Don't use pre-created images
●  Manually install Jenkins in Docker and deploy a multi-agent Jenkins setup in Kubernetes to run CI pipelines.
=> Approach
   - Manually install Jenkins in ubuntu based container (no official image)
   - use .war file and expose on port 8080
   - for k8s run Jenkins master in one pod configure Kubernetes plugin setup agents
   - use templates to auto-provision agents during job execution
