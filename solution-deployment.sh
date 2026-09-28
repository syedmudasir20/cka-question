# Question
# There is a deployment named nodeport-deployment in the relative namespace

# Tasks:
# 1. Configure the deployment so it can be exposed on port 80, name=http, protocol TCP
# 2. Create a new Service named nodeport-service exposing the container port 80, protocol TCP, Node Port 30080
# 3. Configure the new Service to also expose the individual pods using NodePort

# Add container port to deployment
kubectl patch deployment nodeport-deployment -n relative -p '{
  "spec":{"template":{"spec":{"containers":[{
    "name":"nginx",
    "ports":[{"name":"http","containerPort":80,"protocol":"TCP"}]
  }]}}}}'
kubectl get deploy nodeport-deployment -n relative -o wide

# Create NodePort service on 30080
cat <<'EOF' > svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
  namespace: relative
spec:
  type: NodePort
  selector:
    app: nodeport-deployment
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    nodePort: 30080
EOF
kubectl apply -f svc.yaml
kubectl get svc nodeport-service -n relative -o wide
# Test: curl http://<nodeIP>:30080


