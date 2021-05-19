# itsonewb-docker
Galaxy Docker for ITSoneWB


```
docker run --privileged --name itsonewb -d -p 8080:80 -p 8021:21 -p 8022:22 -v /export/galaxy_storage/:/export/ ibiomcnr/itsonewb
```
