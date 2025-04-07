FROM almalinux:8

RUN dnf -y update \
 && dnf install -y openssh-server openssh-clients \
 && dnf install -y wget \
 && dnf install -y java-1.8.0-openjdk
 
RUN sed -ri 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
  && sed -ri 's/^#Port 22/Port 20022/' /etc/ssh/sshd_config \
  && echo 'root:password' | chpasswd

RUN cd /opt \
  && wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.53/bin/apache-tomcat-9.0.53.tar.gz \
  && tar zxf apache-tomcat-9.0.53.tar.gz \
  && chmod -R u+x apache-tomcat-9.0.53 \
  && sh /opt/apache-tomcat-9.0.53/bin/startup.sh

COPY ./init/docker_ssh_rsa.pub /root/

RUN mkdir ~/.ssh \
  && chmod 700 ~/.ssh \
  && cat ~/docker_ssh_rsa.pub >> ~/.ssh/authorized_keys \
  && chmod 644 ~/.ssh/authorized_keys

EXPOSE 20022
