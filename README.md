Based on https://github.com/nginx-proxy/nginx-proxy

A new env varaible `ENABLE_ACME` is added to use acme.sh to generate free ssl cert from letsencrypt.

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



