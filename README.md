# Dockerized mailarchiva installation

https://www.mailarchiva.com/ 

* Updated to support MailArchiva v9.0.26
* See docker-compose.yml on how to make your application data and configuration persistent (uses mailarchiva default paths)
* Dockerfile based on: https://github.com/that0n3guy/docker

## Build Example

``` 
docker buildx build . -t quack79/mailarchiva:9.0.26
```

## Run Example

```
docker compose up -d
```