# Create a namespace to house our Services
kubectl create namespace media

# If we want everything to be ssl enabled we need to copy the cert issuers script from the traefik setup
kubectl get secret traefik-cert-secret -n traefik-system -o yaml \
| sed s/"namespace: traefik-system"/"namespace: media"/\
| kubectl apply -n media -f -