FROM ubuntu:20.04
MAINTAINER Carlos delbion.com

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

# Old:
#ENTRYPOINT ["/entrypoint"]
# New: Redirect logs to stdout and a file using 'tee'
ENTRYPOINT ["/bin/sh", "-c", "touch /var/log/entrypoint.log && /entrypoint 2>&1 | while read line; do echo \"`date +'%b %d %H:%M:%S'` $line\"; done | tee -a /var/log/entrypoint.log"]
