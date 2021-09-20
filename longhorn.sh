
# Install longhorn dynamic provisioning system for storage
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml

# Check on pods coming up
kubectl -n longhorn-system get pods

# Test the pvc provided by Longhorn
cat <<EOF | kubectl --kubeconfig $HOME/.kube/config apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 1Gi
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: volume-test
spec:
  containers:
  - name: volume-test
    image: nginx:stable-alpine
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: test-pvc
      mountPath: /data
    ports:
    - containerPort: 80
  volumes:
  - name: test-pvc
    persistentVolumeClaim:
      claimName: test-pvc
EOF

# Install the longhorn ingress to get to the longhorn dashboard
# create a service account for longhorn access
USER=lonmin; PASSWORD="LKFern13!" echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth --kubeconfig $HOME/.kube/config
# create the ingress point
cat <<EOF | kubectl apply --kubeconfig $HOME/.kube/config -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: longhorn-system
  name: longhorn-ingress
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
  - host: longhorn.smtrock.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: longhorn-frontend
            port:
              number: 80
EOF