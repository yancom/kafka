$namespace = 'kafka'

# Create a new namespace for Kafka
kubectl create namespace $namespace

# Add Bitnami Helm repository and update
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Deploy Kafka using Helm in the 'kafka' namespace with 3 replicas
helm install kafka bitnami/kafka --namespace $namespace --set replicaCount=3

# Verify Kafka pods in the 'kafka' namespace
kubectl get pods --namespace $namespace

# Deploy Kafka client pod in the 'kafka' namespace
kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:latest --namespace $namespace --command -- sleep infinity

# Wait for the Kafka client pod to be in running state
kubectl wait --for=condition=ready pod/kafka-client --namespace $namespace --timeout=120s

# Connect to the Kafka client pod to create the topic
kubectl exec --tty -i kafka-client --namespace $namespace -- bash -c "kafka-topics.sh --create --bootstrap-server kafka-0.kafka-headless.$namespace.svc.cluster.local:9092,kafka-1.kafka-headless.$namespace.svc.cluster.local:9092,kafka-2.kafka-headless.$namespace.svc.cluster.local:9092 --replication-factor 3 --partitions 1 --topic health_checks_topic"

# List topics to verify creation
kubectl exec --tty -i kafka-client --namespace $namespace -- bash -c "kafka-topics.sh --list --bootstrap-server kafka-0.kafka-headless.$namespace.svc.cluster.local:9092,kafka-1.kafka-headless.$namespace.svc.cluster.local:9092,kafka-2.kafka-headless.$namespace.svc.cluster.local:9092"
