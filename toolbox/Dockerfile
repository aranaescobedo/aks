# Use Ubuntu 18.04 as base image
FROM ubuntu:18.04

# Install required packages
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y default-mysql-client && \
    apt-get install -y dnsutils && \
    apt-get install -y iputils-ping && \
    apt-get install -y nmap && \
    apt-get install -y postgresql-client && \
    apt-get install -y telnet && \
    apt-get install -y traceroute && \
    apt-get install -y wget

# Run as non root user
RUN groupadd -r -g 999 toolboxgrp && useradd --no-log-init -u 999 -r -g toolboxgrp toolbox
USER toolbox
