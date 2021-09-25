curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add traefik https://helm.traefik.io/traefik

helm repo update
# create namespace
kubectl create namespace --traefik-system 

# create a secret for the cloudflare dns token
kubectl create secret generic clourdflare --from-literal=dns-token={$dnsToken} -n traefik-system

helm install --namespace=traefik-system --create-namespace traefik traefik/traefik -f traefik-values.yaml

# Final step is create an ingress route 
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik-system
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(\`traefik.smrtrock.com\`) # Hostname to match
      kind: Rule
      services: # Service to redirect requests to
        - name: api@internal # Special service created by Traefik pod
          kind: TraefikService
EOF

# Secure access
cat <<EOF | kubectl apply -f -
---
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: auth
  namespace: traefik-system
spec:
  basicAuth:
    namespace: traefik-system
    secret: traefik-auth

---
apiVersion: v1
kind: Secret
metadata:
  name: traefik-auth
  namespace: traefik-system
data:
  users: |1
   dDItYWRtaW46JGFwcjEkU1JxNUZOVXIkZ1dzYkdhRWtTVE1oRWxzRk5nNVYzLgo=
EOF


# Update ingress route to inclue the middleware
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik-system
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(\`traefik.smrtrock.com\`) # Hostname to match
      kind: Rule
      services: # Service to redirect requests to
        - name: api@internal # Special service created by Traefik pod
          kind: TraefikService
      # Enable auth middleware
      middlewares:
        - name: auth
EOF
