Based on https://github.com/jwilder/nginx-proxy

A new env varaible `ENABLE_ACME` is added to use acme.sh to generate free ssl cert from letsencrypt.

All the other options are the same as the upstream project: https://github.com/jwilder/nginx-proxy

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
--name proxy \
neilpang/nginx-proxy
```

It's recommended to run with `--net=host` option, like:

```sh
docker run  \
-it  -d --rm  \
-v /var/run/docker.sock:/tmp/docker.sock:ro  \
-v $(pwd)/proxy/certs:/etc/nginx/certs \
-v $(pwd)/proxy/acme:/acmecerts \
-v $(pwd)/proxy/conf.d:/etc/nginx/conf.d \
--name proxy \
--net=host \
neilpang/nginx-proxy
```

For a docker compose v2 or v3 project, every project has a dedicated network, so, you must use `--net=host` option,  so that it can proxy any projects on you machine.


#### Docker Compose
```yaml
version: '2'

services:
  nginx-proxy:
    image: neilpang/nginx-proxy
    ports:
      - "80:80"
      volumes:
        - /var/run/docker.sock:/tmp/docker.sock:ro
        - ./proxy/certs:/etc/nginx/certs
        - ./proxy/acme:/acmecerts
        - ./proxy/conf.d:/etc/nginx/conf.d
      network_mode: "host"
```


### 2. Run an internal webserver

```sh
docker run -itd --rm \
-e VIRTUAL_HOST=foo.bar.com \
-e ENABLE_ACME=true \
httpd

```



