# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018-2021 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

ARG UBUNTU_RELEASE=noble-20250404
FROM ubuntu:$UBUNTU_RELEASE

ARG KODI_VERSION=20.5

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive


ARG KODI_EXTRA_PACKAGES=

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-*            enables the use of gamepads, joysticks, game controllers, etc.
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
#  - va-driver-all                the full suite of drivers for the Video Acceleration API (VA API)
RUN packages="                                               \
    wget                                                     \
    ca-certificates                                          \
    kodi=2:${KODI_VERSION}+*                                 \
    kodi-repository-kodi \
    kodi-eventclients-kodi-send                              \
#    kodi-api-inputstream \
    kodi-inputstream-adaptive                                \
    kodi-inputstream-rtmp                                    \
# kodi-peripheral-joystick                                 \
# kodi-peripheral-xarcade                                  \
    locales                                                  \
    pulseaudio                                               \
    tzdata                                                   \
    va-driver-all                                            \
    mesa-va-drivers                                           \
    mesa-vdpau-drivers                                       \
    ${KODI_EXTRA_PACKAGES}"                               && \
                                                             \                                    
    apt-get update                                        && \
    apt-get install -y --no-install-recommends $packages  && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*

# download working version of TED addon in /add-ons folder
RUN mkdir /add-ons && \
   wget https://github.com/Kevwag-Kodi-Forks/plugin.video.ted.talks/releases/download/v5.0.1/plugin.video.ted.talks-5.0.1.zip -O /add-ons/plugin.video.ted.talks-5.0.1.zip && \
    #wget https://github.com/moreginger/xbmc-plugin.video.ted.talks/archive/refs/heads/feature/matrix.zip -O /add-ons/xbmc-plugin.video.ted.talks.zip && \
    wget https://github.com/add-ons/plugin.video.vrt.nu/archive/refs/heads/master.zip -O /add-ons/plugin.video.vrt.nu.zip

# ignore poweroff key on RF remote control
COPY --chown=root logind.conf /etc/systemd/logind.conf

# setup entry point
COPY entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
