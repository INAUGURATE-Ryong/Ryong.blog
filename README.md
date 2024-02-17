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

