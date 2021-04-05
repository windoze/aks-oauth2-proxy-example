AKS and OAuth2 Proxy
====================


1. Install nginx ingress controller with `--set controller.service.externalTrafficPolicy=Local` parameter, it will ensure AKS to use real IP to access the ingress.

2. After the creation of the ingress controller, add an `A` record in the DNS zone, point "*" to this IP address, otherwise you need to create DNS record for every app with different subdomain.

3. Create secret to store AAD App Client Secret with the command `kubectl create secret generic oauth2-secrets --from-literal=clientSecret=<CLIENT_SECRET>`

4. Install oauth2-proxy.yaml.
    * Doc says to allow request with valid JWT token to be sent directly to the app, we need `--skip-jwt-bearer-tokens=true`, but seems `--extra-jwt-issuers=https://sts.windows.net/<TENANT_ID>/=<CLIENT_ID>` is also needed. Otherwise the request will be redirected to Microsoft login page.

5. Create ingress with `ingress.yaml`.
    * Add annotation `nginx.ingress.kubernetes.io/auth-response-headers: X-Auth-Request-Access-Token, Authorization, X-Forwarded-User, X-Forwarded-Groups, X-Forwarded-Email, X-Forwarded-Preferred-Username' to enable extra headers to be sent to app.
    * Annotation `nginx.ingress.kubernetes.io/proxy-buffer-size: "16k"` is needed or the cookie will be truncated and failed to be verified.
    * <OAUTH2_PROXY_COOKIE_SECRET> is a 32-letter random string, used to encrypt oauth2 cookie.