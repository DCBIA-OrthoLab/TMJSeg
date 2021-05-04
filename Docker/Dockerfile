FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && apt-get install -y \
        wget \
        zip \
	libxt6 \
	openjdk-8-jdk \
	xserver-xorg

# Matlab runtime 9.5
RUN mkdir matlab_install matlab
RUN wget https://ssd.mathworks.com/supportfiles/downloads/R2018b/deployment_files/R2018b/installers/glnxa64/MCR_R2018b_glnxa64_installer.zip && \
    unzip MCR_R2018b_glnxa64_installer.zip -d matlab_install
RUN /app/matlab_install/install -mode silent -agreeToLicense yes -destinationFolder /app/matlab
RUN rm -rf MCR_R2018b_glnxa64_installer.zip && \
    rm -rf MCR_R2018b_glnxa64_installer
    
RUN wget https://github.com/DCBIA-OrthoLab/tmjseg/releases/download/v1.0.0/TMJSeg
RUN chmod +x ./TMJSeg

ENV LD_LIBRARY_PATH=/app/matlab/v95/runtime/glnxa64:/app/matlab/v95/bin/glnxa64:/app/matlab/v95/sys/os/glnxa64:/app/matlab/v95/sys/opengl/lib/glnxa64

RUN mkdir /app/.nvm

ENV NVM_DIR=/app/.nvm
ENV NODE_VERSION v14.16.0

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
	&& . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && npm i clusterpost-execution -g

ENV PATH=/app:$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

