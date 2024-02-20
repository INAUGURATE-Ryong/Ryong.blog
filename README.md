## Ryong.blog

- 무중단 배포 만들기 실습

## 요구사항
- blog 를 fly.io 에 A,B 배포
- lb 를 fly.io 1곳에 배포
- lb 를 통해 들어가면 fly.io blog A, B 가 순차 적으로 보임
- A, B 중 하나를 업데이트 하는 동안 서비스는 중단 되지 않음

## local 환경 TEST
- 각 도커파일 및 필요 파일 [link](https://github.com/INAUGURATE-Ryong/Ryong.blog/pull/3)
### build
```
$ sudo docker build -t zdd:0.1.0 .
$ sudo docker build -t lb:0.1.0 .
```

### RUN
```
$ sudo docker run -d --name blogA -p 6001:80  zdd:0.1.0
$ sudo docker run -d --name blogA -p 6002:80  zdd:0.1.0
$ sudo docker run -d --name lb -p 6000:80 lb:0.1.0
```

### NETWORK
```
$ docker network create blog
$ sudo docker network connect blog blogA
$ sudo docker network connect blog blogB
$ sudo docker network connect blog lb

$ sudo docker network inspect blog
```

## branch 240217/lb 
- 각 서버 폴더 및 default.conf 파일 수정
- 각 폴더에서 배포 진행
- 배포를 진행할 떄에는 Build,Run 진행 안해도 됨.
```
$ flyctl deploy
```
```
zdd_docker
    ├── blogA
    │   ├── Dockerfile
    │   ├── blog-pull-cronjob
    │   ├── fly.toml
    │   └── pull.sh
    ├── blogB
    │   ├── Dockerfile
    │   ├── blog-pull-cronjob
    │   ├── fly.toml
    │   └── pull.sh
    └── lb
        ├── Dockerfile
        ├── config
        │   └── default.conf
        └── fly.toml
```

| 서버명 | 서버이름 |
|---|---|
| BlogA | https://bloga.fly.dev/ |
| BlogB | https://blogb.fly.dev/ |
| LB | https://lb-server.fly.dev/ |

## Docker Compose
```

# BUILD 

$ docker build -t memento12/testblog-a -f zdd_docker/blogA/Dockerfile  zdd_docker/blogA/  <- 이렇게 안되면 밑에처럼 Dockerfile경로 들어가서 따로따로 진행
$ sudo docker build -t testblog-a .
$ sudo docker tag testblog-a memento12/testblog-a:0.1.0

$ sudo docker images
REPOSITORY             TAG       IMAGE ID       CREATED              SIZE
memento12/testblog-b   latest    767491be6235   About a minute ago   260MB
memento12/testblog-a   latest    aedc2a90f5d2   About a minute ago   260MB

$ sudo docker push memento12/testblog-a:0.1.0
Using default tag: latest
The push refers to repository [docker.io/memento12/testblog-a]
4ba2d418a093: Pushed
8d83284cd25f: Pushed
331fcfe3a22c: Pushed
e0b18b578156: Pushed
0711a0c9bdd7: Pushed
d280e4367266: Pushed
2bf5c256d213: Pushed
6f89c6a710a3: Pushed
f9c44fabb1a3: Pushed
d101c9453715: Mounted from library/ubuntu

$ sudo docker push memento12/testblog-b
Using default tag: latest
The push refers to repository [docker.io/memento12/testblog-b]
fa54ba4f654a: Pushed
fa9d72590f51: Pushed
331fcfe3a22c: Mounted from memento12/testblog-a
e0b18b578156: Mounted from memento12/testblog-a
0711a0c9bdd7: Mounted from memento12/testblog-a
d280e4367266: Mounted from memento12/testblog-a
2bf5c256d213: Mounted from memento12/testblog-a
6f89c6a710a3: Mounted from memento12/testblog-a
f9c44fabb1a3: Mounted from memento12/testblog-a
d101c9453715: Mounted from memento12/testblog-a
latest: digest: sha256:e166a6d8d3cdf6ccbd624cbb15ecaf6b5a4631843ec7c7702c0dbfe078dd186b size: 2414
```
# compose run
```
docker compose -f zdd_docker/compose.yml  up -d --build --force-recreate

```

