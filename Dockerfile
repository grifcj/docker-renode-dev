FROM ubuntu:20.04

# Install mono
RUN apt update \
   && apt install -y --no-install-recommends gnupg ca-certificates \
   && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
   && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
   && apt update \
   && apt install -y --no-install-recommends mono-complete

# Ensure tzdata doesn't interrupt headless install
ARG DEBIAN_FRONTEND=non-interactive
ENV TZ=America/Los_Angeles

# Install monodevelop
RUN apt install -y --no-install-recommends apt-transport-https dirmngr \
   && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
   && echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | tee /etc/apt/sources.list.d/mono-official-vs.list \
   && apt update \
   && apt install -y --no-install-recommends monodevelop monodevelop-nunit gsettings-desktop-schemas

# Install dependencies for renode build.
RUN apt install -y --no-install-recommends \
   git automake autoconf libtool g++ coreutils policykit-1 libgtk2.0-dev screen \
   uml-utilities gtk-sharp2 python3 python3-dev python3-pip

# Remove cached apt information to reduce size
RUN rm -rf /var/lib/apt/lists/*

# Install dependencies for running tests. Taken from tests/requirements.txt in renode repo.
RUN python3 -m pip install \
   robotframework==3.1 \
   netifaces \
   requests \
   psutil \
   pyyaml

WORKDIR /workdir
CMD monodevelop
