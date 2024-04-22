# MQTT

MQTT is a standard messaging protocol designed specifically for use in IoT applications. It requires a so called MQTT broker.
The broker is at the heart of the system. It is responsible for receiving all messages, filtering them, and sending them to the subscribers, here the MQTT clients. An MQTT broker can potentially handle millions of connected MQTT clients.

You can create the ebusd container though the following script. The ports may depend on your system.

```sh
docker run -d -p 1883:1883 --name mqtt --restart=always -v /home/pi/data/mqtt_data/mosquitto.conf:/mosquitto/config/mosquitto.conf eclipse-mosquitto:2
```

The mosquitto.conf can be changed to your needs, here is a minimal example which I use.

```conf
allow_anonymous true
```
