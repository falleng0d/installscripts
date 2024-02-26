# Use Ubuntu as the base image
FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y software-properties-common

# create ubuntu user
RUN useradd -m -s /bin/bash ubuntu

# Set the working directory in the container
WORKDIR /home/ubuntu

COPY ./install-packages.sh .
RUN ./install-packages.sh

# Copy the current directory contents into the container at /home
COPY *.sh .

RUN chmod +x ./*.sh

# Run install-essential.sh script
RUN USER=ubuntu HOME=/home/ubuntu ./install-essential.sh

USER ubuntu

ENTRYPOINT [ "fish" ]
