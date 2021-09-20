# K8Dashboard
# Optional install the K8 dashboard WebUI
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# Create Admin user for dashboard
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# set permissions for admin user
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Get the bearer token to log into the dashboard
kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token

# Start the kube proxy to allow this remote machine to access the Dashboard
kubectl proxy 

## You can now open a browser and navigate to http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
# Log in with the aforementioned token
