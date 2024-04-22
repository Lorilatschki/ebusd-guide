# Portainer

Portainer is a management tool that provides a user-friendly interface to manage the Docker host and containers. This way you can easily create, start and stop you container via a webserver.
You can follow the [How to Install Portainer on a Raspberry Pi](https://www.wundertech.net/portainer-raspberry-pi-install-how-to-install-docker-and-portainer/) guide or you can create the portainer container though the following script. The ports may depend on your system.

```sh
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/pi/data/portainer_data:/data portainer/portainer-ce:latest
```

>The portainer web UI can be accessed through ``IP_ADDRESS_RASPBERRY_PI:9443``.

Once you are finished, you can add further container through portainer itself.

## Updating portainer

Since updating portainer through portainer UI isn't possible, the following script might be helpful.

```sh
docker stop portainer
docker rm portainer
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/pi/data/portainer_data:/data portainer/portainer-ce:latest
```

## PuTTY

Portainer is very useful to change existing contains, however sicne it does not provide to import a container setup, you need to configure it manually though the user interface. Therefor I prefer to setup the container via ssh console. Once it is created, chanching parameters becomes very convenient.

To connect with the raspberry Pi I prefer using the tool [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
To connect to it, you need to configure the IP address and the port ``22``. After that click open and type in the user (default is ``pi``) and the password.
