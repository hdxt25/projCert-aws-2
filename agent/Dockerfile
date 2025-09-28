# Base Ubuntu image
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

USER root

# Update & install required packages
RUN apt-get update && apt-get install -y \
    openssh-client \
    git \
    python3 \
    python3-pip \
    ansible \
    docker.io \
    sudo \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



# Switch to root
USER root
RUN mkdir -p /.ansible && chmod -R 777 /.ansible
RUN mkdir -p ./work 

WORKDIR /work

# Default command
CMD ["bash"]