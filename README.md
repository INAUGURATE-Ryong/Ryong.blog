## Ryong.blog

- 무중단 배포 만들기 실습

## 요구사항
- blog 를 fly.io 에 A,B 배포
- lb 를 fly.io 1곳에 배포
- lb 를 통해 들어가면 fly.io blog A, B 가 순차 적으로 보임
- A, B 중 하나를 업데이트 하는 동안 서비스는 중단 되지 않음

## branch 240217/lb 
- 각 서버의 폴더링 및 파일 생성
