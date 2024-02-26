# Use Ubuntu as the base image
FROM ubuntu:latest

# Set the working directory in the container
WORKDIR /home

# Copy the current directory contents into the container at /home
COPY . /home

# Run install-essential.sh script
RUN chmod +x ./install-essential.sh

RUN USER=root ./install-essential.sh
