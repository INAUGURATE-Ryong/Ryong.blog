version: '3.8'
name: awsgoo
services:
  nginx-proxy:
    image: nginxproxy/nginx-proxy # https://github.com/nginx-proxy/nginx-proxy
    ports:
      - "9989:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
    depends_on:
      - blog
    deploy:
      resources:
        limits:
          cpus: '0.10'
          memory: 50M
        reservations:
          cpus: '0.05'
          memory: 20M

  blog:
    # build: ../../docker_file/httpd
    image: memento12/testblog-a:0.1.0
    deploy:
      mode: replicated
      replicas: 1 # https://docs.docker.com/compose/compose-file/deploy/#replicas
      resources: # https://docs.docker.com/compose/compose-file/compose-file-v3/#resources
        limits:
          cpus: '0.05'
          memory: 50M
        reservations:
          cpus: '0.01'
          memory: 20M
    expose:
      - "80"
    environment:
      - VIRTUAL_HOST=aws.google.com
      - VIRTUAL_PORT=80
