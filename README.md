# ebusd-ochsner

This repository describes how to setup a infrastructure to control a eBUS based heating pump, in this case a Ochsner GMSW 10 HK plus (OTE3). You can setup the same for every other eBUS based heading pump, the only difference are the ebusd specific configurations.

## Helpful links

The following links are very helpful and might help understanding different topcis

- [Docker Simplified: A Hands-On Guide for Absolute Beginners](https://www.freecodecamp.org/news/docker-simplified-96639a35ff36/)
- [ebusd wiki](https://github.com/john30/ebusd/wiki)
- [eBUS Adapter Shield v5](https://adapter.ebusd.eu/v5/)
- [A brief introduction to Node-RED](https://noderedguide.com/nr-lecture-1/)
- [MQTT beginner’s guide](https://www.u-blox.com/en/blogs/insights/mqtt-beginners-guide#:~:text=MQTT%20is%20a%20publish%2Dand,topics%20handled%20by%20a%20broker.)
- [Why Portainer](https://www.portainer.io/why-portainer)

## Component overview

```mermaid
%%{init: {'theme':'dark'}}%%
graph LR  
    subgraph Heating System  
        Pump[Heating Pump] -->|controls| Adapter[eBus Adapter]  
        Pi[Raspberry Pi] -->|uses| Adapter  
        Router[Router] -->|network connection| Pi  
        Router -->|network connection| Adapter  
  
        subgraph Raspberry Pi  
            subgraph Docker Host  
                NodeRed[Node-RED]  
                Ebusd[ebusd]  
                MqttBroker[MQTT Broker]  
                Portainer[Portainer]  
            end  
  
            Docker -->|communicates with| Adapter  
            NodeRed -->|publishes/subscribes| MqttBroker  
            Ebusd -->|publishes/subscribes| MqttBroker  
            Portainer -->|manages| Docker  
        end  
    end  

```

The heating system is composed of several interconnected components that work together to control and monitor the heating pump. The central control unit of this system is a Raspberry Pi, which is connected to the network via a general router.

### Components

- **Heating Pump:** The primary device responsible for circulating heat transfer fluid throughout the heating system.
- **eBus Adapter:** An interface device that enables communication between the heating pump and the Raspberry Pi.
- **Router:** A network device that facilitates data communication between the Raspberry Pi, the eBus Adapter, and potentially other networked devices.
- **Raspberry Pi:** A compact computer that hosts a Docker environment and serves as the brain of the system. It uses the eBus Adapter to interface with the heating pump.

### Docker Host on Raspberry Pi

Within the Raspberry Pi, a Docker host is running to manage and isolate different software components using containers. The following containers are in operation:

- **Node-RED:** A programming tool for wiring together hardware devices, APIs, and online services in new and interesting ways. It can be used to create automation flows.
- **ebusd:** A daemon for handling communication with eBus devices like the heating pump. It interfaces with the eBus Adapter to control and monitor the pump.
- **MQTT Broker:** A message broker that supports the MQTT protocol. It allows for efficient and reliable communication between the Node-RED and ebusd containers.
- **Portainer:** A management tool that provides a user-friendly interface to manage the Docker host and containers.

### Network Connections

The Raspberry Pi and the eBus Adapter both connect to the network through the Router, enabling remote access and control. This setup allows for monitoring and managing the heating system from a networked computer or a smart device.
>You can also connect the eBUS adapter via usb to your raspberry PI, there it might be necessary to install ebusd directly on you raspberry PI instead of running them inside a docker container.

The Docker containers on the Raspberry Pi communicate with each other and with external devices through the MQTT Broker and eBus Adapter, creating a robust and flexible control system for the heating pump.

## Step by step guide

The following steps provide a step by step guide to setup such an environment from the scratch.

### Raspberry PI

By following the [getting started](https://www.raspberrypi.com/documentation/computers/getting-started.html) you setup you raspberry PI. You should wire it with a ethernet cable directly to router/switch.

### Docker on Raspberry PI

Here is a [Install Docker on Raspberry Pi](https://www.simplilearn.com/tutorials/docker-tutorial/raspberry-pi-docker) guide you can follow.

### eBUS Adapter Shield v5

You need to wire the adapter with your headpump via a eBUS two-core cable. You can take a usual KNX wire for that EIB Y-(ST)-Y 2x2x0,8 or EIB Y-(ST)-Y 2x2x0,8. You should also add use a USR-ES1 Modul mit W5500 to connect your adapter with you network via ethernet cable.
For detailed instruction refer to [eBUS Adapter Shield v5](https://adapter.ebusd.eu/v5/).

### Docker Container general

Since container are running in an isolated environment similar to a sandbox, it is recommended to map a volume to each container in order to persist data. Best practise is, to create a ``/home/pi/data`` folder where you store you container specific config files.
Following this aproche you end up with the following structure:

- ``/home/pi/data/ebusd``
- ``/home/pi/data/mqtt_data``
- ``/home/pi/data/node_red_data``
- ``/home/pi/data/portainer_data``

### Portainer

Portainer is a management tool that provides a user-friendly interface to manage the Docker host and containers. This way you can easily create, start and stop you container via a webserver.
You can follow the [How to Install Portainer on a Raspberry Pi](https://www.wundertech.net/portainer-raspberry-pi-install-how-to-install-docker-and-portainer/) guide.

Once you are finished, you can add further container through portainer itself.

#### Updating portainer

Since updating portainer through portainer UI isn't possible, the following script might be helpful.

```sh
docker stop portainer
docker rm portainer
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/pi/data/portainer_data:/data portainer/portainer-ce:latest
```

### PuTTY

Portainer is very useful to change existing contains, however sicne it does not provide to import a container setup, you need to configure it manually though the user interface. Therefor I prefer to setup the container via ssh console. Once it is created, chanching parameters becomes very convenient.

To connect with the raspberry PI I prefer using the tool [https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html](PuTTY).
To connect to it, you need to configure the IP address and the port ``22``. After that click open and type in the user (default is ``pi``) and the password.

### ebusd

**eBUSd**(eamon) is a daemon for handling communication with eBUS devices connected to a 2-wire bus system ("energy bus" used by numerous heating systems).

#### ebusd configuration

Copy the configuration from https://github.com/Lorilatschki/ebusd-ochsner/tree/main/configuration/ochsner to you ``/home/pi/data/ebusd/ochsner``.
You can use every ssh tool for that, I prefer [FileZilla](https://filezilla-project.org/download.php?platform=win64).

You can create the ebusd container though the following script. The ports may depend on your system.

```sh
docker run --name ebusd -it -p 8888 john30/ebusd --scanconfig -d enh:192.168.1.135:5001 --latency=10 -r
```

### Node-RED

Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways. Since I have my dashboard already in nodered, I have integrated the eBUS there as well.

You can create the nodered container though the following script. The ports may depend on your system.

```sh
docker run --name nodered --restart=always -e TZ=Europe/Berlin -p 502:502 -p 1880:1880 -p 1883:1883 -p 3671:3671 -p 9522:9522/udp -v /home/pi/data/node_red_data:/data nodered/node-red:latest
```
