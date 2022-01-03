# mariadb-docker

### Launch Docker Image into a Container, Using:

The following command downloads and launches the already built image from Docker Hub (https://hub.docker.com/r/hammadrauf/mariadb)

```
docker run --name mariadb01 -d -p 3306:3306 hammadrauf/mariadb
```


### Stop  Container, Using (Database will persist until Container is removed):

```
docker stop mariadb01
```

### Start Already Launched Image (Container) Again, Using (Test Database persistance):

```
docker start mariadb01
```

### To connect to started Container BASH shell:

```
docker exec -it mariadb01  /bin/bash
```

### List All (Active and Non Active) Containers: 

```
docker ps -a
```

### Remove a Container Freeing all resources and deleting Databases, Using:

```
docker rm -f mariadb01
```

### List All Local Images, Using:

```
docker image ls
```

### Delete Particular Image, Using:

```
docker image rm <<IMAGE ID>>
docker image rm b45e3b4b08de
```

### Prune (Delete) unused Images, Using:

```
docker image prune
```

## Build  Customized Image Using:

To custimize the Docker Image and build it yourself locally perform the following steps.
### First clone Git Code locally:
```
git clone https://github.com/hammadrauf/mariadb-docker.git
cd mariadb-docker
```
Now do your edits to the Dockerfile or other scripts.

### Now Build using:
```
docker build -t mariadb .
docker build -t mariadb --build-arg ARG_MYSQL_DB_NAME=yahoodb --build-arg ARG_PU_PWD=hello02 .
```

### To run your customized local Image locally (After sucessful build)
```
docker run --name mariadb01 -d -p 3306:3306 mariadb
```

## All of the Defined Arguments (ARG) are as follows:
```
ARG_ROOT_PWD (Default=changeme01)
ARG_POWER_USER (Default=ceaser)
ARG_PU_PWD (Default=changeme02)
ARG_MYSQL_DB_NAME (Defaults to my_db)
```

## All of the Environment-Variables (ENV) are as follows:
```
container (Default=docker)
TERM (Default=linux)
DEBIAN_FRONTEND (Default=noninteractive)
MYSQL_DB_NAME (Default = $ARG_MYSQL_DB_NAME or my_db, if ARG is not defined)
```

## Build Image for DockerHub:

```
docker build --tag <<Your DockerHub Account Name>>/mariadb .
```

## Manual Push Image to Docker Hub:
```
docker push .....
```
