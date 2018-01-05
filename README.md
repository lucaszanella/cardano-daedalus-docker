# cardano-daedalus-docker

Forked to one dockerfile and no other dependencies for better reading and less confusion. Builds the node and wallet into the same thing and runs them. Took off docker-compose for less problematic stuff. 

# Building
```
git clone https://github.com/lucaszanella/cardano-daedalus-docker

cd cardano-daedalus-docker

sudo docker build -t daedalus .
```

### Manual start
- Initial start: `docker run -d --name=daedalus  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY `
- Stop: `docker stop daedalus`
- Start: `docker start daedalus`(This does not work so once you stop this image you loose the synced blockchain!)


