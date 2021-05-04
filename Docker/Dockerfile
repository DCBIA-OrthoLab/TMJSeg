FROM ubuntu:focal

WORKDIR /app

RUN apt-get update && apt-get install -y \
        wget \
        zip \
	libxt6 \
	openjdk-8-jdk

RUN wget https://ssd.mathworks.com/supportfiles/downloads/R2018b/deployment_files/R2018b/installers/glnxa64/MCR_R2018b_glnxa64_installer.zip
RUN mkdir MCR_R2018b_glnxa64_installer
RUN unzip MCR_R2018b_glnxa64_installer.zip -d MCR_R2018b_glnxa64_installer
RUN MCR_R2018b_glnxa64_installer/install -mode silent -agreeToLicense yes

ENV LD_LIBRARY_PATH=/lib/x86_64-linux-gnu/:/usr/local/MATLAB/MATLAB_Runtime/v95/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v95/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v95/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v95/extern/bin/glnxa64:$LD_LIBRARY_PATH

RUN wget https://github.com/DCBIA-OrthoLab/tmjseg/releases/download/v1.0.0/TMJSeg
RUN chmod +x ./TMJSeg

RUN mkdir /app/.nvm

ENV NVM_DIR=/app/.nvm
ENV NODE_VERSION v14.16.0

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
	&& . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && npm i clusterpost-execution -g

ENV PATH=/app:$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

