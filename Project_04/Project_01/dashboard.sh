#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

LAST_PLAYBOOK_LOG="/tmp/ansible-playbook.log"

check_image() {
  if docker images | grep -q 'ansible-node'; then
    echo -e "[${GREEN}OK${NC}] Docker image 'ansible-node' exists"
  else
    echo -e "[${RED}NOT BUILT${NC}] Docker image 'ansible-node' missing"
  fi
}

check_k8s_pods() {
  echo -e "K8s Pods:"
  local pods=$(kubectl get pods 2>/dev/null | grep -E 'master|node1|node2')
  if [[ -z "$pods" ]]; then
    echo -e "  [${RED}DOWN${NC}] No ansible pods running"
  else
    echo "$pods" | while read -r line; do
      name=$(echo "$line" | awk '{print $1}')
      ready=$(echo "$line" | awk '{print $2}')
      status=$(echo "$line" | awk '{print $3}')
      if [[ "$status" == "Running" && "$ready" == "1/1" ]]; then
        echo -e "  [${GREEN}READY${NC}] $line"
      elif [[ "$status" == "Running" ]]; then
        echo -e "  [${YELLOW}PARTIAL${NC}] $line"
      else
        echo -e "  [${RED}$status${NC}] $line"
      fi
    done
  fi
}

check_k8s_svcs() {
  echo -e "K8s Services:"
  local svcs=$(kubectl get svc 2>/dev/null | grep -E 'node1|node2')
  if [[ -z "$svcs" ]]; then
    echo -e "  [${RED}DOWN${NC}] No ansible services running"
  else
    echo "$svcs" | while read -r line; do
      name=$(echo "$line" | awk '{print $1}')
      clusterip=$(echo "$line" | awk '{print $3}')
      if [[ "$clusterip" != "<none>" ]]; then
        echo -e "  [${GREEN}OK${NC}] $line"
      else
        echo -e "  [${RED}ERROR${NC}] $line"
      fi
    done
  fi
}

check_sudoers() {
  echo "Sudoers on nodes:"
  for node in node1 node2; do
    status=$(kubectl exec $node -- bash -c "grep -q 'ansible ALL=(ALL) NOPASSWD:ALL' /etc/sudoers.d/ansible && echo OK || echo MISSING" 2>/dev/null)
    if [[ "$status" == "OK" ]]; then
      echo -e "  $node: [${GREEN}OK${NC}]"
    elif [[ "$status" == "MISSING" ]]; then
      echo -e "  $node: [${RED}MISSING${NC}]"
    else
      echo -e "  $node: [${YELLOW}Not reachable${NC}]"
    fi
  done
}

show_playbook_result() {
  if [[ -f "$LAST_PLAYBOOK_LOG" ]]; then
    echo -e "Last Ansible playbook run: $(date -r $LAST_PLAYBOOK_LOG)"
    grep -E 'PLAY|TASK|ok=|changed=|failed=|unreachable=|PLAY RECAP' $LAST_PLAYBOOK_LOG | tail -20
  else
    echo -e "[${YELLOW}No playbook run yet.${NC}]"
  fi
}

main_menu() {
  clear
  echo "===== Ansible-K8s DevOps Dashboard ====="
  echo
  check_image
  echo
  check_k8s_pods
  echo
  check_k8s_svcs
  check_sudoers
  echo
  show_playbook_result
  echo
  echo "----------------------------------------"
  echo "Available actions:"
  echo "1) Build Docker image"
  echo "2) Start Kubernetes cluster (pods/services)"
  echo "3) Grant sudo rules to nodes"
  echo "4) Open Ansible master shell"
  echo "5) Run playbook (logs output here!)"
  echo "6) Show full Kubernetes status"
  echo "7) Tear down Kubernetes cluster"
  echo "8) Clean up Docker containers/networks"
  echo "0) Exit"
  echo
}

while true; do
  main_menu
  read -p "Choose an option: " opt
  case $opt in
    1) make build ;;
    2) make k8s-up ;;
    3) make grant-sudo ;;
    4) make shell ;;
    5)
      echo "Launching playbook runner..."
      kubectl exec -it master -- bash -c "su - ansible -c 'cd ~/ansible && ansible-playbook -i hosts hello.yml'" | tee $LAST_PLAYBOOK_LOG
      ;;
    6) make status ;;
    7) make k8s-down ;;
    8) make clean-docker ;;
    0) echo "Goodbye!"; break ;;
    *) echo "Invalid choice, try again." ;;
  esac
  read -p "Press Enter to return to dashboard..."
done

