# docker-gophernicus

An Alpine Linux based Docker image for the Gophernicus Gopher server (https://github.com/gophernicus/gophernicus).

Do you just want to run a simple Gopher service? Do you not want to mess the hassle of setting up old-school inetd/xinetd/systemd sockets/etc? Are you already running all your other services as containers? Well so did I!

This image runs Gophernicus via xinetd on an Alpine Linux base for a Docker image that weighs in at just a smidge under 7MB. Set your hostname, point your favorite volume at `/var/gopher`, bind port 70 and go!

ex:
```
docker build -t gophernicus .

docker run --name gophernicus \
	--hostname <your gopher hostname> \
	-p 70:70 \
	-v <your gopher root>:/var/gopher \
	gophernicus
```

## TODO

- Logging to stdout
- Configuration via environment variables
