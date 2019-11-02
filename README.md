# VirtualBMC

 [![Docker Automated build](https://img.shields.io/docker/automated/solidcommand/virtualbmc.svg)](https://hub.docker.com/r/solidcommand/virtualbmc/) [![Docker Pulls](https://img.shields.io/docker/pulls/solidcommand/virtualbmc.svg)](https://hub.docker.com/r/solidcommand/virtualbmc/) [![Docker Stars](https://img.shields.io/docker/stars/solidcommand/virtualbmc.svg)](https://hub.docker.com/r/solidcommand/virtualbmc/) [![](https://images.microbadger.com/badges/image/solidcommand/virtualbmc:1.6.0.svg)](https://microbadger.com/images/solidcommand/virtualbmc:1.6.0 "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/solidcommand/virtualbmc:1.6.0.svg)](https://microbadger.com/images/solidcommand/virtualbmc:1.6.0 "Get your own version badge on microbadger.com")


## About

This is a Docker image for the [OpenStack VirtualBMC project ](https://github.com/openstack/virtualbmc)

## Building

To build the project:
```shell
make
```

To list the images:
```shell
make list
```

To run any tests:
```shell
make test
```

To push image to remote docker repository:
```shell
REPO_PASSWORD='MyPassword!$' make push
```

To update README on remote docker repository (docker hub):

```shell
REPO_PASSWORD='MyPassword!$' make push-readme
```

To cleanup and remove built images:
```shell
make clean
```

## Usage

The below example shows how to use this container by mounting an ssh key into the `virtualbmc` user's directory.
This will start the VirtualBMC Daemon (`vbmcd`) and attach to your host's network.  

To run the container:  

```shell
docker run -d -v /home/someuser/.ssh/id_rsa:/virtualbmc/.ssh/id_rsa:ro --name virtualbmc --network host solidcommand/virtualbmc
```

Once you have started the daemon you can add hosts on a remote box by using something like the following:  

```shell
docker exec -i -t virtualbmc vbmc add node01 --port 6230 --libvirt-uri 'qemu+ssh://root@my-libvirthost.example.com/system' --no-daemon
docker exec -i -t virtualbmc vbmc add node02 --port 6231 --libvirt-uri 'qemu+ssh://root@my-libvirthost.example.com/system' --no-daemon
docker exec -i -t virtualbmc vbmc start 'node01' --no-daemon
docker exec -i -t virtualbmc vbmc start 'node02' --no-daemon
docker exec -i -t virtualbmc vbmc list
```

On your host machine you should be able to run IPMI commands:  

```shell
ipmitool -I lanplus -U admin -P password -H 127.0.0.1 -p 6230 power status
```

