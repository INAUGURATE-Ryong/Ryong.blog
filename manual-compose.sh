e!/bin/bash

#var
BLOG_1 = "blog-a-1.internal"
BLOG_2 = "blog-b-1.internal"

# rm & rmi
figlet remove all
sudo docker stop $(sudo docker ps -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi $(sudo docker images -q)


figlet build blog-a , blog-b
# blog-a build
sudo docker build -t blog-a  -f zdd_docker/blogA/Dockerfile  zdd_docker/blogA
# blog-b build
sudo docker build -t blog-b  -f zdd_docker/blogB/Dockerfile  zdd_docker/blogB


figlet run blog-a , blog-b
# blog-a run
sudo docker run -d --name $BLOG_1 -p 8001:80  blog-a
# blog-b run
sudo docker run -d --name $BLOG_2 -p 8002:80  blog-b

# docker network rm & create
figlet NW rm&create&connect
sudo docker networkd rm  dockerfileNW
sudo docker network create dockerfileNW
sudo docker network connect dockerfileNW blog-a-1
sudo docker network connect dockerfileNW blog-b-1

figlet build lb
# lb build
sudo docker build -t lb  -f zdd_docker/lb/Dockerfile  zdd_docker/lb

figlet run lb
# lb nun
sudo docker run -d --name lb-1 -p 8000:80 lb

#network
figlet network lb
sudo docker network connect dockerfileNW lb-1

figlet ps
sudo docker ps

#inspect
sudo docker network inspect dockerfileNW


# end
# sl -aF
