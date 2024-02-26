# Use Ubuntu as the base image
FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y software-properties-common sudo

# Set the working directory in the container
WORKDIR /home/ubuntu

COPY ./scripts/install-packages.sh .
RUN ./install-packages.sh

# create ubuntu user
RUN useradd -m -s /bin/bash ubuntu
RUN echo "ubuntu:ubuntu" | chpasswd
RUN adduser ubuntu sudo

# Add user to root group
RUN usermod -aG root ubuntu

# Allow root group to create folders and files on /home
RUN chmod g+w /home

# Copy the current directory contents into the container at /home
COPY scripts/*.sh .

RUN chmod +x ./*.sh

# Run install-essential.sh script
RUN USER=ubuntu HOME=/home/ubuntu ./install-essential.sh

USER ubuntu

ENTRYPOINT [ "fish" ]
