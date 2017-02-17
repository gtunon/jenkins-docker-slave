FROM maven:3.3.9-jdk-8
MAINTAINER Guiomar Tunon <gtunon@naevatec.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y git
# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:2uS61XUq" | chpasswd

RUN mkdir /home/jenkins/.m2

ADD settings.xml /home/jenkins/.m2/

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ 

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
