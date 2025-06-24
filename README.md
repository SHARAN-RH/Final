4. Automate Docker Image Creation and Deployment using Jenkins Pipeline 
=> Note: Create Jenkins from scratch, no image pulling
●  Jenkins pipelines must be configured to build Docker images and push to a self-hosted registry.
=> Approach
   - Manually install Jenkins and Docker
   - Set up a local Docker registry
   - Create Jenkins file with steps: Git clone - Docker build - Docker push
   - No use of DockerHub or prebuilt Jenkins image
