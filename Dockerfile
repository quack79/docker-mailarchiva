FROM phusion/baseimage:0.9.22

# Version: 5.4.1
ENV MAILARCHIVA_BASE_URL https://mailarchiva.com/download?id=1020
ENV MAILARCHIVA_INSTALL_DIR /opt
ENV MAILARCHIVA_HEAP_SIZE 2048m

# this is based on http://phusion.github.io/baseimage-docker/
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y expect wget iproute

# Get the teamcity package and extract it.
RUN wget -q -O - $MAILARCHIVA_BASE_URL | tar xzf - -C $MAILARCHIVA_INSTALL_DIR
RUN mv $MAILARCHIVA_INSTALL_DIR/mailarchiva* $MAILARCHIVA_INSTALL_DIR/mailarchiva

# Install mailarchiva - use expect to automate the interactive install
ADD expect-install $MAILARCHIVA_INSTALL_DIR/mailarchiva/expect-install
RUN cd $MAILARCHIVA_INSTALL_DIR/mailarchiva && expect expect-install

# run mailarchiva on startup
RUN mkdir -p /etc/my_init.d
ADD run-mailarchiva.sh /etc/my_init.d
RUN chmod +x /etc/my_init.d/run-mailarchiva.sh

# web
EXPOSE 8090
#smtp
EXPOSE 8091
#milter
EXPOSE 8092

# RUN apt-get remove -yf expect... leave this hear for easy updates? 
RUN apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /usr/share/locale/* /usr/share/man/* /usr/share/doc/*
