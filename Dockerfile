# Using baseimage-docker ( http://phusion.github.io/baseimage-docker/ )
FROM phusion/baseimage:0.9.17

# Update system and install java packages and ruby
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget software-properties-common python-software-properties && \
    add-apt-repository -y ppa:webupd8team/java && \
    add-apt-repository -y ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer oracle-java8-unlimited-jce-policy && \
    apt-get install -y ruby2.3 ruby2.3-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install rundeck
RUN wget -O /opt/rundeck.deb http://dl.bintray.com/rundeck/rundeck-deb/rundeck-2.6.1-1-GA.deb && \
  dpkg -i /opt/rundeck.deb && \
  rm -rf /opt/rundeck.deb /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change base configuration
RUN mkdir /etc/service/rundeck && \
  mkdir /var/lib/rundeck/.ssh && \
  chown -R rundeck:rundeck /var/lib/rundeck

# Add init and startup scripts
ADD assets/run/rundeck.sh /etc/service/rundeck/run
ADD assets/startup/* /etc/my_init.d/

# Open 4440
EXPOSE 4440

# Configure rundeck setups - WIP
VOLUME [ "/var/rundeck", "/etc/rundeck", "/var/lib/rundeck/.ssh", "/var/log/rundeck" ]

# /etc/my_init.d should work automatically but it doesn't work w/o this part
CMD ["/sbin/my_init"]
