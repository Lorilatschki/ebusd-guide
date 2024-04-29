# ebusd

**eBUSd**(eamon) is a daemon for handling communication with eBUS devices connected to a 2-wire bus system ("energy bus" used by numerous heating systems).

## ebusd configuration

Copy the configuration from https://github.com/Lorilatschki/ebusd-ochsner/tree/main/configuration/ochsner to you ``/home/pi/data/ebusd/ochsner``.
You can use every ssh tool for that, I prefer [FileZilla](https://filezilla-project.org/download.php?platform=win64).

You can create the ebusd container though the following script. The ports may depend on your system.

```sh
docker run -d --name ebusd --restart=always -p 8888 -p 8080 -v /home/pi/data/ebusd_data:/etc/ebusd john30/ebusd:latest -d enh:IP_ADDRESS_EBUS_ADAPTER:9999 --latency=10 --configpath=/etc/ebusd/ochsner --pollinterval=5 --mqtthost=IP_ADDRESS_RASPBERRY_PI --mqttport=1883
```

The ``IP_ADDRESS_EBUS_ADAPTER`` need to be replaced by the IP of your eBUS adapter. The ``IP_ADDRESS_RASPBERRY_PI`` need to be replaced by the IP of your raspberry Pi.
