# mariadb (docker image source)

This is not the official mariadb Docker Image source. 

### Launch Docker Image into a Container, Using:

The following command downloads and launches the already built image from Docker Hub (https://hub.docker.com/r/hammadrauf/mariadb)

```
docker run --name mariadb01 -d -p 3306:3306 -v mysql-data:/var/lib/mysql hammadrauf/mariadb
```
OR
The Following command downloads and launches the already built image from Quay.io Regsitry (https://quay.io/repository/hammadrauf/mariadb)

```
docker run --name mariadb01 -d -p 3306:3306 -v mysql-data:/var/lib/mysql quay.io/hammadrauf/mariadb
```

### Mount Volume on Host folder in Linux/Windows
You can mount the volume on the Host server that is running the Docker Container system.
```
On Linux:
	$ docker run --name mariadb01 -d -p 3306:3306 -v /home/user01/mysql-data:/var/lib/mysql hammadrauf/mariadb
	
On Windows:
	C:\> docker run --name mariadb01 -d -p 3306:3306 -v "C:\\Users\\user01\\mysql-data":/var/lib/mysql hammadrauf/mariadb

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
ARG_ROOT_PWD
ARG_POWER_USER
ARG_PU_PWD
ARG_MYSQL_DB_NAME
```

## All of the Environment-Variables (ENV) are as follows:
```
container (Default=docker)
TERM (Default=linux)
DEBIAN_FRONTEND (Default=noninteractive)
MYSQL_DB_NAME (Default = $ARG_MYSQL_DB_NAME or my_db, if ARG is not defined)
ROOT_PWD (Default to changeme01)
POWER_USER (Default to ceaser)
PU_PWD (Default to changeme02)
```

## Run Image with Environment Variables
```
On Linux:
	$ docker run --name mariadb01 -d -p 3306:3306 -v /home/user01/mysql-data:/var/lib/mysql -e MYSQL_DB_NAME:newdbname hammadrauf/mariadb
```


## Build Image for DockerHub/Quay.io/Container Registry:

```
docker build --tag <<Your Account Name>>/mariadb .
```

## Manual Push Image to Docker Hub OR Quay.IO:
```
docker push ........
```

---

## Taking Backup of Volumes and Restoring Volumes from Backup

### Backup Steps:
1. First stop the running target container.
```
	docker stop mycontainer
```	
2. Choose a Host backup folder or make one if does not exist.
3. Spin a temporary docker container with Host mounted backup folder + plus the predefined volume, and backup the files.
```
	On Linux Host:
		$ docker run --rm -v myvolume1:/copythis -v /home/user01/backups:/backups ubuntu bash -c "cd /copythis && tar czvf /backup/site-backup.tar.gz ."
	On Windows Host:
		C:\> docker run --rm -v myvolume1:/copythis -v "C:\\Users\\user01\\docker_volumes\\backups":/backups ubuntu bash -c "cd /copythis && tar czvf /backup/site-backup.tar.gz ."
```		

### Restore Steps:
1. Create a volume that will contain recovered data.
```
	docker volume create my-recovered-volume
```	
2. Spin a temporary docker container with Host mounted backups folder + new volume.
```
	On Linux Host:
		$ docker run --rm -v my-recovered-volume:/recover -v /home/user01/backups:/backups ubuntu bash -c “cd /recover && tar xzvf /backups/site-backup.tar.gz"
	On Windows Host:
		C:\> docker run --rm -v my-recovered-volume:/recover -v "C:\\Users\\user01\\docker_volumes\\backups":/backups ubuntu bash -c "cd /recover && tar xzvf /backups/site-backup.tar.gz"
```		
3. Start the target container with my-recovered-volume mounted at the correct mount point.	

### Remote Backup:
For critical data Remote backup of backup should be performed.
