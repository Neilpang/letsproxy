Based on https://github.com/nginx-proxy/nginx-proxy

A few new env variables are added to use acme.sh to generate free ssl cert from letsencrypt.
- `ENABLE_ACME` => Set to `true` on other containers to enable certificate generation
- `ACME_DNS` => Set to `true` on this container to enable DNS-01 challenge
- `DNS_HOOK` => Set to one of the DNS hook script from the acme.sh script. This also adds the various environment variables used by the hook script specified. ie: `AD_API_KEY` for the dns_ad hook.


All the other options are the same as the upstream project.
It's very easy to use:

### 1. Run nginx reverse proxy

```sh
docker run  \
-p 80:80 \
-p 443:443 \
-it  -d --rm  \
-v /var/run/docker.sock:/tmp/docker.sock:ro  \
-v $(pwd)/proxy/certs:/etc/nginx/certs \
-v $(pwd)/proxy/acme:/acmecerts \
-v $(pwd)/proxy/conf.d:/etc/nginx/conf.d \
-v $(pwd)/vhost.d:/etc/nginx/vhost.d \
-v $(pwd)/stream.d:/etc/nginx/stream.d \
-v $(pwd)/dhparam:/etc/nginx/dhparam \
--name proxy \
neilpang/letsproxy
```

It's recommended to run with `--net=host` option, like:

```sh
docker run  \
-it  -d --rm  \
-v /var/run/docker.sock:/tmp/docker.sock:ro  \
-v $(pwd)/proxy/certs:/etc/nginx/certs \
-v $(pwd)/proxy/acme:/acmecerts \
-v $(pwd)/proxy/conf.d:/etc/nginx/conf.d \
-v $(pwd)/vhost.d:/etc/nginx/vhost.d \
-v $(pwd)/stream.d:/etc/nginx/stream.d \
-v $(pwd)/dhparam:/etc/nginx/dhparam \
--name proxy \
--net=host \
neilpang/letsproxy
```

For a docker compose v2 or v3 project, every project has a dedicated network, so, you must use `--net=host` option,  so that it can proxy any projects on you machine.


#### Docker Compose
```yaml
version: '2'

services:
  letsproxy:
    image: neilpang/letsproxy
    ports:
      - "80:80"
      - "443:443"
      volumes:
        - /var/run/docker.sock:/tmp/docker.sock:ro
        - ./proxy/certs:/etc/nginx/certs
        - ./proxy/acme:/acmecerts
        - ./proxy/conf.d:/etc/nginx/conf.d
        - ./proxy/vhost.d:/etc/nginx/vhost.d 
        - ./proxy/stream.d:/etc/nginx/stream.d 
        - ./proxy/dhparam:/etc/nginx/dhparam 
      network_mode: "host"
```


### 2. Run an internal webserver

```sh
docker run -itd --rm \
-e VIRTUAL_HOST=foo.bar.com \
-e ENABLE_ACME=true \
httpd

```



