# .gitpod.Dockerfile

# Base image with common development tools
FROM gitpod/workspace-full:latest

# Install required bioinformatics tools and dependencies
RUN sudo apt-get update && sudo apt-get install -y \
    python3-pip \
    perl \
    curl \
    unzip

# Install CutAdapt
RUN pip3 install cutadapt

# Download and install FastQC
RUN curl -O https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && \
    unzip fastqc_v0.11.9.zip && \
    chmod +x FastQC/fastqc && \
    sudo mv FastQC/fastqc /usr/local/bin/

# Download and install Trim Galore
RUN curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o trim_galore.tar.gz && \
    tar xvzf trim_galore.tar.gz && \
    sudo mv TrimGalore-0.6.6/trim_galore /usr/local/bin/

# Clean up to reduce image size
RUN rm -rf fastqc_v0.11.9.zip trim_galore.tar.gz TrimGalore-0.6.6

# Set working directory
WORKDIR /workspace
