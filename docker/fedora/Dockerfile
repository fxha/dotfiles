FROM fedora:31

RUN dnf install -y git sudo

# # Create a user
# RUN useradd -ms /bin/bash dev
# RUN usermod -aG wheel dev
# RUN echo "dev    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
# # RUN echo "dev    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/skip_pwd
# RUN chown -R dev:dev /home/dev

# # Add dotfiles and chown
# ADD . /home/dev/.dotfiles

# # Switch user
# USER dev
# ENV HOME /home/dev
# ENV TZ Europe/Berlin
# ENV GIT_AUTHOR_NAME dev
# ENV GIT_AUTHOR_EMAIL dev@local

# # Change working directory
# WORKDIR /home/dev/.dotfiles

# # Run installer
# RUN /home/dev/.dotfiles/install.sh --accept-mscorefonts-eula --no-interaction --log-path=/dev/stdout

# CMD ["/bin/bash"]

# -----------------------------------------------

# WORKAOURND: Fedora >28 ask always for a password in non-interactive sudo mode and "NOPASSWD".
#   --> a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper

# Add dotfiles to root user
ADD . /root/.dotfiles

# Set environment
ENV HOME /root
ENV TZ Europe/Berlin
ENV GIT_AUTHOR_NAME dev
ENV GIT_AUTHOR_EMAIL dev@local

# Change working directory
WORKDIR /root/.dotfiles

# Run installer
RUN /root/.dotfiles/install.sh --root --accept-mscorefonts-eula --no-interaction --log-path=/dev/stdout

CMD ["/bin/bash"]
