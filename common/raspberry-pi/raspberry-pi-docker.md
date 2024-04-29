# Raspberry Pi and Docker

By following the [getting started](https://www.raspberrypi.com/documentation/computers/getting-started.html) you setup your raspberry Pi. You should wire it with a ethernet cable directly to a router/switch.

## Docker on Raspberry Pi

Here is a [Install Docker on Raspberry Pi](https://www.simplilearn.com/tutorials/docker-tutorial/raspberry-pi-docker) guide you can follow.

## Docker Volumes

Since container are running in an isolated environment similar to a sandbox, it is recommended to map a volume to each container in order to persist data. Best practise is, to create a ``/home/pi/data`` folder where you store your container specific config files.
Following this approach you end up with the following structure:

- ``/home/pi/data/ebusd``
- ``/home/pi/data/mqtt_data``
- ``/home/pi/data/node_red_data``
- ``/home/pi/data/portainer_data``
