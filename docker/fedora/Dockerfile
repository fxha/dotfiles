FROM fedora:30

RUN dnf install -y git sudo

# create a user
RUN useradd -ms /bin/bash dev
RUN echo "dev    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo '%sudo  ALL=(ALL)     NOPASSWD: ALL' >> /etc/sudoers
RUN chown -R dev:dev /home/dev

# add dotfiles and chown
ADD . /home/dev/.dotfiles

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
