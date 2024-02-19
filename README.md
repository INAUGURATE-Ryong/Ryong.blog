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
$ docker build -t memento12/testblog-a -f zdd_docker/blogA/Dockerfile  zdd_docker/blogA/
$ docker build -t memento12/testblog-b -f zdd_docker/blogB/Dockerfile  zdd_docker/blogB/
$ sudo docker images
REPOSITORY             TAG       IMAGE ID       CREATED              SIZE
memento12/testblog-b   latest    767491be6235   About a minute ago   260MB
memento12/testblog-a   latest    aedc2a90f5d2   About a minute ago   260MB

$ sudo docker push memento12/testblog-a
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

# compose run
```
docker compose -f zdd_docker/compose.yml  up -d --build --force-recreate

[+] Running 14/14
 ✔ nginx-proxy 13 layers [⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]      0B/0B      Pulled                                                                                                      8.7s
   ✔ e1caac4eb9d2 Pull complete                                                                                                                                      3.0s
   ✔ 88f6f236f401 Pull complete                                                                                                                                      2.6s
   ✔ c3ea3344e711 Pull complete                                                                                                                                      0.7s
   ✔ cc1bb4345a3a Pull complete                                                                                                                                      1.4s
   ✔ da8fa4352481 Pull complete                                                                                                                                      2.1s
   ✔ c7f80e9cdab2 Pull complete                                                                                                                                      2.7s
   ✔ 18a869624cb6 Pull complete                                                                                                                                      2.8s
   ✔ 66ab28d11695 Pull complete                                                                                                                                      3.3s
   ✔ 79b57e45edb0 Pull complete                                                                                                                                      3.4s
   ✔ 2be787a40ace Pull complete                                                                                                                                      5.4s
   ✔ 563a441cec03 Pull complete                                                                                                                                      4.0s
   ✔ 4994460aae36 Pull complete                                                                                                                                      4.1s
   ✔ 4f4fb700ef54 Pull complete                                                                                                                                      4.6s
[+] Running 2/3
 ⠹ Network awsgoo_default          Created                                                                                                                           1.2s
 ✔ Container awsgoo-blog-1         Started                                                                                                                           0.6s
 ✔ Container awsgoo-nginx-proxy-1  Started                                                                                                                           1.0s
```
