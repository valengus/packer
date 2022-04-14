FROM centos:7

ENV LANG en_US.UTF-8

RUN yum check-update; \
    yum install -y python3 git sshpass; \
    yum install -y python3-pip; \
    yum clean all

RUN pip3 install --upgrade pip; \
    pip3 install ansible==4.4.0
    # ansible-galaxy collection install ...

COPY ansible.cfg /etc/ansible/ansible.cfg

CMD ["/usr/sbin/init"]