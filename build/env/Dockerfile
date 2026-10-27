# DeeX Reproducible Build Environment Dockerfile
# Status: Draft
# Date: 2025-05-16
# Master Plan Sections: 2.1, 2.2, 2.4
#
# Primary Source Citation for Base OS & Host Packages:
# https://source.android.com/docs/setup/start/initializing (Access Date: 2025-05-16, Confidence: VERIFIED)

# Pinned base image digest for Ubuntu 22.04 LTS
FROM ubuntu:22.04@sha256:e0f80c829509ef4df9e76bd8944eb7b8ec25cbb379b112a7f9448b2c77a77c9b

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install official AOSP required host build packages and repo dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bc \
    bison \
    build-essential \
    ca-certificates \
    curl \
    flex \
    fontconfig \
    git \
    gnupg \
    libc6-dev-i386 \
    libgl1-mesa-dev \
    libx11-dev \
    libxml2-utils \
    lsof \
    procps \
    python3 \
    python3-pip \
    python-is-python3 \
    rsync \
    unzip \
    x11proto-core-dev \
    zip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Google repo tool
RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
    && chmod a+rx /usr/local/bin/repo

# Create non-root unprivileged build user for containerized execution
RUN groupadd -g 1000 deexbuilder \
    && useradd -u 1000 -g deexbuilder -m -s /bin/bash deexbuilder

USER deexbuilder
WORKDIR /workspace/deex

CMD ["/bin/bash"]
