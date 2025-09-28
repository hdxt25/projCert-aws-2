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

# Add jenkins user and give sudo privileges
RUN useradd -m -s /bin/bash jenkins \
    && echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && usermod -aG docker jenkins

# Set HOME environment variable
ENV HOME=/home/jenkins

# Switch to jenkins user
USER jenkins
RUN mkdir -p /home/jenkins/.ansible && chown -R jenkins:jenkins /home/jenkins/.ansible

WORKDIR /home/jenkins/agent-workspace

# Default command
CMD ["bash"]