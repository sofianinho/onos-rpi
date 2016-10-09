FROM resin/armv7hf-debian
MAINTAINER Sofiane Imadali <sofiane.imadali@orange.com>
LABEL version="1.8.0-docker-armv7l"
LABEL description="ONOS for Raspberry Pi"


# Add Java and Onos tarballs
ADD https://drive.google.com/open?id=0BzbivnzUyTDtdmxSMVhodHJoYm8 /tmp/jdk.tar.gz
ADD https://drive.google.com/open?id=0BzbivnzUyTDtcnRzX0pZOGpiVGM /tmp/onos.tar.gz 

# Set the environment variables
ENV HOME /root
ENV JAVA_HOME /opt/jdk1.8.0_101/
ENV KARAF_VERSION 3.0.5
ENV KARAF_ROOT /root/onos-1.8.0.docker-armv7l/apache-karaf-3.0.5
ENV KARAF_LOG /root/onos-1.8.0.docker-armv7l/apache-karaf-3.0.5/data/log/karaf.log
ENV PATH $PATH:$KARAF_ROOT/bin

# Untar and install
RUN /usr/bin/cross-build-start &&\
    tar xfz /tmp/jdk.tar.gz -C /opt &&\
    update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_101/bin/javac 1 &&\
    update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_101/bin/java 1 &&\
    tar xfz /tmp/onos.tar.gz -C /root/ &&\
    rm -rf /tmp/* &&\
    /usr/bin/cross-build-end


# Change to /root directory
WORKDIR /root/onos-1.8.0.docker-armv7l

# Ports
# 6653 - OpenFlow
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS CLUSTER COMMUNICATION
EXPOSE 6653 8181 8101 9876
ENTRYPOINT ["./bin/onos-service"]
