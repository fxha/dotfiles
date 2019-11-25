FROM fedora:30

RUN dnf install -y git sudo

# add dotfiles and chown
ADD . /home/root/.dotfiles

ENV TZ Europe/Berlin
ENV GIT_AUTHOR_NAME root
ENV GIT_AUTHOR_EMAIL root@local

# change working directory
WORKDIR /home/root/.dotfiles

# run installer
RUN /home/root/.dotfiles/install.sh --root --dotfiles --accept-mscorefonts-eula --no-interaction --log-path=/dev/stdout

CMD ["/bin/bash"]
