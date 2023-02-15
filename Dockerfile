FROM ubuntu:23.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    samtools \
    tabix \
    python3 \
    python3-pip \
    r-base \
    libcurl4-openssl-dev

RUN R -q -e "setRepositories(graphics = FALSE, ind = 1:6); install.packages(c(\"sequenza\", \"optparse\"))"
RUN pip install sequenza-utils

COPY scripts/sequenza-command.sh \
    scripts/sequenza-command.R \
    /opt/
