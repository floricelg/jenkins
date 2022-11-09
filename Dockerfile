FROM centos:7

RUN yum -y install openssh-server

RUN useradd remote_user && \
    echo "xxxx" | passwd remote_user  --stdin && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user   -R /home/remote_user && \
    chmod 400 /home/remote_user/.ssh/authorized_keys

RUN ssh-keygen -A

CMD /usr/sbin/sshd -D

#####################################################

FROM ubuntu:18.04

RUN apt-get update && \
 apt-get install -y openssh-server

RUN useradd remote_user && \
    echo "remote_user:xxxx" | chpasswd && \
    mkdir /home/remote_user/.ssh -p && \
    chmod 700 /home/remote_user/.ssh && \
    mkdir -p -m0755 /var/run/sshd

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user   -R /home/remote_user && \
    chmod 400 /home/remote_user/.ssh/authorized_keys

CMD /usr/sbin/sshd -D
