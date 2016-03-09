FROM docker.io/centos:7
MAINTAINER Akihiro Matsushima <amatsusbit@gmail.com>

ARG USER=builder
ARG UID=501
ARG DIST=el7

RUN yum -y update && \
    yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
    yum -y install mock rpmdevtools sudo vim wget && \
    yum clean all && \
    useradd -u $UID -g mock $USER && \
    echo -e 'Defaults:root\t!requiretty\n%mock\tALL=(ALL)\tNOPASSWD: ALL' > \
        /etc/sudoers.d/mock && \
    sudo -u $USER rpmdev-setuptree && \
    echo -e "\n%dist .$DIST" >> /home/$USER/.rpmmacros && \
    echo "alias mock='/usr/bin/mock --resultdir=\$HOME/rpmbuild/RPMS/mock-result'" >> \
         /home/$USER/.bashrc && \
    if [ $DIST != "el7" ]; then \
      sed -i -e "s/'el7/'$DIST/" \
          -e "/\['releasever/a config_opts\['macros'\]\['%dist'\] = \".$DIST\"" \
          /etc/mock/epel-7-x86_64.cfg; \ 
    fi

USER $USER
WORKDIR /home/$USER/rpmbuild
