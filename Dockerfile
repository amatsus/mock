FROM docker.io/centos:7
LABEL maintainer="Akihiro Matsushima <amatsusbit@gmail.com>"

ARG MOCKUSER=mock
ARG MOCKUID=501
ARG MOCKDIST=el7

RUN yum -y update && \
    yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm && \
    yum -y install mock rpmdevtools sudo vim wget && \
    yum clean all && rm -rf /var/lib/yum/yumdb && rm -rf /var/lib/yum/history && rm -rf /var/tmp/yum* && \
    rpm --rebuilddb && \
    useradd -u $MOCKUID -g mock $MOCKUSER && \
    echo -e 'Defaults:root\t!requiretty\n%mock\tALL=(ALL)\tNOPASSWD: ALL' > \
        /etc/sudoers.d/mock && \
    su -c rpmdev-setuptree $MOCKUSER && \
    rm -f /var/log/*log && rm -f /var/log/?tmp && \
    echo -e "\n%dist .$MOCKDIST\n%buildid .bit" >> /home/$MOCKUSER/.rpmmacros && \
    echo 'alias mock="/usr/bin/mock $MOCKOPTS"' >> /home/$MOCKUSER/.bashrc && \
    if [ $MOCKDIST != "el7" ]; then \
      sed -i -e "s/'el7/'$MOCKDIST/" \
          -e "/\['releasever/a config_opts\['macros'\]\['%dist'\] = \".$MOCKDIST\"" \
          -e "$ i \\\n[go-repo]\nname=Go-repo - CentOS\nbaseurl=file:///home/$MOCKUSER/rpmbuild/repo/x86_64/\ngpgcheck=0\nenabled=1" \
          /etc/mock/epel-7-x86_64.cfg; \ 
    fi

USER $MOCKUSER
WORKDIR /home/$MOCKUSER/rpmbuild

ENTRYPOINT [ "/usr/bin/mock", "${MOCKOPTS}" ]
CMD ["--help"]
