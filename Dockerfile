FROM ubuntu:24.04

# Author label
LABEL maintainer="Yucheng Zhang <Yucheng.Zhang@tufts.edu>"

# Help message
LABEL description="This container contains miniconda-py38 installed on ubuntu:24.04."

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
    
# Download and install Anaconda
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends build-essential wget git ca-certificates locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh  \
    && bash Miniconda3-py38_23.11.0-2-Linux-x86_64.sh  -b -p /opt/conda \
    && rm -f Miniconda3-py38_23.11.0-2-Linux-x86_64.sh  

# Update conda and clean
RUN conda update --all \
    && conda clean --all --yes \
    && rm -rf /root/.cache/pip

# Update some common python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
    
# Set default shell to bash
SHELL ["/bin/bash", "-c"]
