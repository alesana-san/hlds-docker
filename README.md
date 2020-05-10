# Dockerfile for building an image for Half-Life Dedicated Server

### Description

This image allows you easily run a HLDS server built on a `debian:stretch` image (see: [link](https://developer.valvesoftware.com/wiki/SteamCMD)).

Main features are:
+ Configurable running
+ `metamod`, `amxmodx`, `dproto` installed
+ Removed all unusable stuff to make the image use less space

### Usage notes

First off, if you are using Windows 10 host and you want to configure your server (edit `.cfg` files, put extra maps, `amxx` mods, etc) you have to create a shareable folder on your host and share it for an exact user.

See example:
+ Create user `steam` with a password `steam` on your host machine
+ Create a folder on a disc that shared in your `Docker Desktop for Windows` (for example, it's `F:\hlds`)
+ Put some dummy file in the folder (for example, `1.txt`, see Cheat-sheet section for details)
+ Share this folder for user `steam` giving him full access (here's [an explanation](https://lifehacker.com/how-to-share-a-folder-over-your-network-5808814))
+ Create docker volume (see Cheat-sheet) providing following values:
  * `<HOST>`=`//10.0.75.1` (docker default host IP-address)
  * `<PATH>`=`hlds` (shared folder)
  * `<SHARE_USER>`=`steam`
  * `<SHARE_PASS>`=`steam`
+ Run a container using a command: `docker run --rm -it krow7/hlds -v somevol:/home/steam/opts -p 27015:27015/udp bash`
  * `--rm` means your container will be removed after exiting
  * `-it` is for interacting with a container
  * `-v somevol:/home/steam/opts` mounts your shared folder to a dir with maps, configuration, etc
  * `-p 27015:27015/udp` maps your host port `27015` to the same port inside of the container. Feel free to change your host port

### Configuration

After first start of a container you will get the following structure in your mounted folder:
```
│   
├───amxx
│   ├───configs
│   │       amxx configs...
│   │       
│   ├───logs
│   │       amxx logs...
│   │       
│   ├───modules
│   │       amxx modules...
│   │       
│   └───plugins
│           amxx plugins...
│           
├───config
│       dproto.cfg
│       listenserver.cfg
│       mapcycle.txt
│       motd.txt
│       plugins.ini
│       server.cfg
│       
└───maps
        your cs maps...
```
You can put maps, `amxx` stuff and so on in a dirs above, however, your extra `.cfg` files won't be executed just by putting then to `config` dir and using `exec myfile.cfg`.

If you want to share more files to be able to modify, create an issue for a modification `dockerfile` or feel free to make a pull request.


### Cheat-sheet
+ Create docker volume using cifs (not a regular `-v` mount, see [this](https://github.com/docker/for-win/issues/2042)):
```
docker volume create `
	--opt type=cifs `
    --opt device=<HOST>/<PATH> `
    --opt o=username=<SHARE_USER>,password=<SHARE_PASS>,noserverino,file_mode=0777,dir_mode=0777,uid=1000,gid=1000 `
    somevol
```
Note: use `uid=1000` and `gid=1000` as it's a `steam` user inside a container.
Using of `noserverino` is also explained in a `for-win` post above.

+ Build an image:
```
docker build -t krow7/hlds .
```

+ Run a new container (debug):
```
docker run --rm -p 27015:27015/udp -v somevol:/home/steam/opts --user root -it krow7/hlds bash
```
+ Run a new container (running interactive to pass commands to console with `somevol` volume created):
```
docker run --rm -p 27015:27015/udp -v somevol:/home/steam/opts -i krow7/hlds
```

### Known issues:
1. Dproto doesn't work on this server build because of hlds update. But it is still added to the image.