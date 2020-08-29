# docker in docker, kubectl, jdk8, maven, nodejs, used for gitlab-ci-runner 
# Author : yqsas
# Ref: https://github.com/bitnami/bitnami-docker-kubectl

FROM bitnami/kubectl:1.18-debian-10

USER root
# 更换国内源
RUN sed -i "s@http://deb.debian.org@http://mirrors.163.com@g" /etc/apt/sources.list && \
    sed -i "s@security.debian.org@mirrors.163.com/debian-security@g" /etc/apt/sources.list && \
    apt-get update
# 安装依赖 Install required system packages and dependencies
RUN install_packages apt-utils unzip git gnupg2 lsb-release software-properties-common 
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && apt-get update && \
    install_packages adoptopenjdk-8-hotspot maven
# 使用内网指定maven 仓库
RUN rm -rf /usr/share/maven/conf/settings.xml
COPY settings.xml  /usr/share/maven/conf/settings.xml

# 安装 Docker    https://docs.docker.com/install/linux/docker-ce/debian/
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88 && add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/debian  $(lsb_release -cs)  stable"
RUN apt-get update && install_packages docker-ce docker-ce-cli containerd.io

# 安装 Node.js   https://github.com/nodesource/distributions
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs && apt-get autoclean && apt-get clean && apt-get autoremove && \
    npm config set registry http://repo.htphy.com:8081/repository/npm-group/

#USER 1001
WORKDIR /root/
