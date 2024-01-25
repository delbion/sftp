FROM debian:bullseye
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
ENTRYPOINT ["bash", "-c", "/entrypoint | tee /var/log/auth_sftp_docker.log"]
