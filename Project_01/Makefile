# ==== Makefile for Ansible Kubernetes Lab ====

# Build the custom Ansible Docker image
build:
	docker build -t ansible-node .

# Set Docker environment to Minikube's Docker daemon
minikube-docker-env:
	eval $$(minikube docker-env)

# Apply Kubernetes pods and services
k8s-up: minikube-docker-env build
	kubectl apply -f ansible-k8s.yaml
	kubectl apply -f ansible-services.yaml

# Delete Kubernetes pods and services (cleanup)
k8s-down:
	kubectl delete -f ansible-k8s.yaml --ignore-not-found
	kubectl delete -f ansible-services.yaml --ignore-not-found

# Show status of pods and services
status:
	kubectl get pods
	kubectl get svc

# Grant sudoers rule for ansible user on both nodes
# (Must be run after pods are created. Needs kubectl access.)
grant-sudo:
	kubectl exec -it node1 -- bash -c "echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible && chmod 440 /etc/sudoers.d/ansible"
	kubectl exec -it node2 -- bash -c "echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible && chmod 440 /etc/sudoers.d/ansible"

# Drop into Ansible master pod as ansible user
shell:
	kubectl exec -it master -- bash -c "su - ansible"

# Clean up Docker containers/networks (if using Docker setup)
clean-docker:
	-docker rm -f master node1 node2
	-docker network rm ansible-net

.PHONY: build minikube-docker-env k8s-up k8s-down status grant-sudo shell clean-docker

