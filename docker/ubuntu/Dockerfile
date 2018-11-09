FROM ubuntu:18.04

RUN apt-get -qq update && apt-get install -qq -y apt-utils git sudo

# create a user
RUN useradd -ms /bin/bash dev
RUN echo "dev    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R dev:dev /home/dev

# add dotfiles and chown
ADD . /home/dev/.dotfiles

# fix tzdata in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV TZ Europe/Berlin
RUN echo "Europe/Berlin" > /etc/timezone
RUN apt-get -qq update && apt-get install -qq -y tzdata
RUN dpkg-reconfigure -f noninteractive tzdata

# switch user
USER dev
ENV HOME /home/dev
ENV TZ Europe/Berlin
ENV GIT_AUTHOR_NAME dev
ENV GIT_AUTHOR_EMAIL dev@local

# change working directory
WORKDIR /home/dev/.dotfiles

# run installer
RUN /home/dev/.dotfiles/install.sh --accept-mscorefonts-eula --no-interaction --log-path=/dev/stdout

CMD ["/bin/bash"]
