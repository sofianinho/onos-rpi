FROM sdhibit/rpi-raspbian
MAINTAINER Sofiane Imadali <sofiane.imadali@orange.com>
LABEL version="1.8.0-docker-armv7l"
LABEL description="ONOS for Raspberry Pi"

# Add Java and Onos tarballs
RUN apt-get update -qq && apt-get install -y --no-install-recommends wget ca-certificates &&\
    wget https://raw.githubusercontent.com/Nanolx/patchimage/master/tools/gdown.pl -O /root/gdown.pl &&\
    chmod +x /root/gdown.pl && touch /tmp/cookie.txt &&\
    /root/gdown.pl 'https://docs.google.com/uc?id=0BzbivnzUyTDtdmxSMVhodHJoYm8&export=download' '/tmp/jdk.tar.gz' &&\
    /root/gdown.pl 'https://docs.google.com/uc?id=0BzbivnzUyTDtcnRzX0pZOGpiVGM&export=download' '/tmp/onos.tar.gz' &&\
    tar xfz /tmp/jdk.tar.gz -C /opt &&\
    update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_101/bin/javac 1 &&\
    update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_101/bin/java 1 &&\
    tar xfz /tmp/onos.tar.gz -C /root/ &&\
    apt-get remove --purge -y wget && apt-get autoremove -y &&\ 
    rm -rf /tmp/* /root/gdown.pl

# Set the environment variables
ENV HOME=/root \
    JAVA_HOME=/opt/jdk1.8.0_101/ \
    KARAF_VERSION=3.0.5 \
    KARAF_ROOT=/root/onos-1.8.0.docker-armv7l/apache-karaf-3.0.5 \ 
    KARAF_LOG=/root/onos-1.8.0.docker-armv7l/apache-karaf-3.0.5/data/log/karaf.log \
    PATH=$PATH:$KARAF_ROOT/bin

# Change to /root directory
WORKDIR /root/onos-1.8.0.docker-armv7l

# Ports
# 6653 - OpenFlow
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS CLUSTER COMMUNICATION
EXPOSE 6653 8181 8101 9876
ENTRYPOINT ["./bin/onos-service"]
