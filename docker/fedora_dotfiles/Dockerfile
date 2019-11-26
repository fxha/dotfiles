FROM fedora:31

RUN dnf install -y git sudo

# Add dotfiles and chown
ADD . /home/root/.dotfiles

ENV TZ Europe/Berlin
ENV GIT_AUTHOR_NAME root
ENV GIT_AUTHOR_EMAIL root@local

# Change working directory
WORKDIR /home/root/.dotfiles

# Run installer
RUN /home/root/.dotfiles/install.sh --root --dotfiles --accept-mscorefonts-eula --no-interaction --log-path=/dev/stdout

CMD ["/bin/bash"]
