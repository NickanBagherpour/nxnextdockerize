# NxNextDockerize


## Build Docker Image from Dockerfile

Run `docker build -t nx-nextjs-doc .` to build image.

## Create Container from Image

Run `docker run -p 3200:3200 --name nx-nextjs-doc-app nx-nextjs-doc` to create and run container.

## Start Container

Run `docker start nx-nextjs-doc-app` to start the container.


## Build And Start Container With Docker Compose 

Run `docker compose up -d` to start container.