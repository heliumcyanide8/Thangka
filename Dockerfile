# Use a smaller base image and update package lists, upgrade installed packages, and install locales
FROM ubuntu:20.04
RUN apt-get update -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y && \
    apt-get install -y locales wget unzip openssh-server

# Set the default locale to en_US.utf8
ENV LANG en_US.utf8

# Define an argument NGROK_TOKEN and set it as an environment variable
ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}

# Download ngrok binary and add it to the PATH
# Download ngrok binary and add it to the PATH
RUN wget -O /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin && \
    rm /tmp/ngrok.zip

# Create a directory for sshd to run
RUN mkdir /run/sshd

# Enable root login and password authentication in sshd configuration
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Set the password for the root user
RUN echo 'root:odiyaan' | chpasswd

# Expose necessary ports
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306 22

# Start the SSH service and ngrok tunnel in the CMD
CMD /usr/sbin/sshd -D & ngrok tcp --region=in 22
