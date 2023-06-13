# docker-kodi


## Preinstallation

Assure that a keyboard and mouse is connected to your Kodi device so that you have a way to configure Kodi.

Note that adding a keyboard/mouse when Kodi container is already running won't wor.  In that case you have to stop and start Kodi.
## Installation

1. Logon (ssh) to the machine where you want to run kodi
2. pull my latest kodi version from docker hub

```
docker pull janvda/kodi:2.1.0
```

3. launch kodi using x11docker.  E.g.

```bash
x11docker --backend=docker   --xorg  -xc  -I       \
            --pulseaudio                           \
            --gpu                                  \
            --wm=none                              \
            --user=jan                             \
            --home=/home/jan/kodi-jan/home2         \
            -- -v kodi-jan-media2:/media:ro -v /run/user/1001/pulse/native:/x11docker/pulseaudio.socket -p 8090:8080 --      \
            janvda/kodi:2.1.0 &
```

4.  Exit the shell (command `exit`) - this will assure that kodi keeps on running.

## Kodi-remote app

Using the **Official Kodi Remote** app from App Store you can control Kodi.

To use this you first need to enable "remote" control in Kodi 
1. via Settings >Services > Control: 
   1. web server > Allow remote control via HTTP
   2. Application Control > Allow remote control from applications on other systems.

## TED add-on installation

1. install the zip version you find in the `/add-ons/` folder
## VRT MAX add-on installation

1. Install the zip version you find in the `/add-ons` folder 
2. Configure it with your VRT max username and password
3. Try playing a file this should install widevine
4. It is normal that playing won't work - you have to stop and start kodi to get it working !!

## Troubeshooting

The log file can be found in folder `~/.kodi/temp/kodi.log`

Enter following command in attached shell

```
more ~/.kodi/temp/kodi.log
```

## Change History

* 2.1.0 (2023-06-12): added latest version of vrt nu add-on in `/add-ons` folder
* 2.0.0 (2023-06-12): Kodi version 20.0 on ubuntu release lunar, TED add-on in `/add-ons` folder
* 1.1.0 (2022-06-28): Kodi version 19.4 - having problems with TED, VRT max.
* 1.0.0 (2022-06-25): First version
# Original Readme from erichough/kodi

Here below the original README.md from erichough/kodi

Dockerized [Kodi](https://kodi.tv/) with audio and video.

![Kodi screenshot](https://kodi.tv/sites/default/files/page/field_image/about--devices.jpg "Kodi screenshot")

## Features

* fully-functional [Kodi](https://kodi.tv/) installation in a [Docker](https://www.docker.com/) container
* **audio** ([ALSA or PulseAudio](https://kodi.wiki/view/Linux_audio)) and **video** (with optional OpenGL hardware 
  video acceleration) via [x11docker](https://github.com/mviereck/x11docker/)
* simple, Ubuntu-based image that adheres to the [official Kodi installation instructions](https://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux#Installing_Kodi_on_Ubuntu-based_distributions)
* clean shutdown of Kodi when its container is terminated

## Host Prerequisites

The host system will need the following:

1. **Linux** and [**Docker**](https://www.docker.com)

   This image should work on any Linux distribution with a functional Docker installation.
   
1. **A connected display and speaker(s)**

   If you're looking for a headless Kodi installation, look elsewhere!

1. **[X](https://www.x.org/) or [Wayland](https://wayland.freedesktop.org/)**

   Ensure that the packages for an X or Wayland server are present on the Docker host. Please consult your distribution's 
   documentation if you're not sure what to install. A display server does *not* need to be running ahead of time.

1. **[x11docker](https://github.com/mviereck/x11docker/)**

   `x11docker` allows Docker-based applications to utilize X and/or Wayland on the host. Please follow the `x11docker` 
   [installation instructions](https://github.com/mviereck/x11docker#installation) and ensure that you have a 
   [working setup](https://github.com/mviereck/x11docker#examples) on the Docker host.
       
## Usage

### Starting Kodi

Use `x11docker` to start the `erichough/kodi` Docker image. Detailing the myriad of `x11docker` options is beyond the 
scope of this document; please consult the [`x11docker` documentation](https://github.com/mviereck/x11docker/) to find 
the set of options that work for your setup.

Below is an example command (split into multiple lines for clarity) that starts Kodi with a fresh X.Org X server with
PulseAudio sound, hardware video acceleration, a persistent Kodi home directory, and a shared read-only Docker mount for
media files:

    $ x11docker --xorg                                 \
                --pulseaudio                           \
                --gpu                                  \
                --homedir /host/path/to/kodi/home      \
                -- -v /host/path/to/media:/media:ro -- \
                erichough/kodi
           
Note that the optional argument passed between a pair of `--` defines additional arguments to be passed to `docker run`.

### Stopping Kodi

You can shut down Kodi just as you normally would; i.e. by using the power menu from the Kodi home screen. 
Behind the scenes, the Docker container and `x11docker` processes will terminate cleanly.

You can also [terminate the container from the command line](doc/advanced.md#command-line-shutdown).

### Example systemd Service Unit

    [Unit]
    Description=Dockerized Kodi
    Requires=docker.service
    After=network.target docker.service
    
    [Service]
    ExecStartPre=/usr/bin/docker pull erichough/kodi
    ExecStart=/usr/bin/x11docker ... erichough/kodi
    Restart=always
    KillMode=process
    
    [Install]
    WantedBy=multi-user.target

## Advanced

The [advanced topics](doc/advanced.md) documentation describes a few more useful features and functionality:

 * [Custom add-ons](doc/advanced.md#custom-add-ons)
 * [Image Variants](doc/advanced.md#image-variants)
 * [Custom Startup Behavior](doc/advanced.md#custom-startup-behavior)
 * [Command-Line Shutdown](doc/advanced.md#command-line-shutdown)

## Help!

Something not working quite right? Are you stuck? Please ask your questions in the
[discussion group](https://github.com/ehough/docker-kodi/discussions), where we exchange help and share ideas.

## Contributing

Constructive criticism and contributions are welcome! Please 
[submit an issue](https://github.com/ehough/docker-kodi/issues/new) or 
[pull request](https://github.com/ehough/docker-kodi/compare).
