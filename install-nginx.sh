helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace <INGRESS_CONTROLLER_NAMESPACE> \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux

