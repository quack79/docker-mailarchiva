# Dockerized mailarchiva installation

https://www.mailarchiva.com/ 

* Updated to support MailArchiva v9.0.26
* See docker-compose.yml on how to make your application data and configuration persistent (uses mailarchiva default paths)

## Run with Docker Compose

```
docker compose up -d
```

## Build Example

``` 
docker buildx build . -t quack79/mailarchiva:9.0.26
```