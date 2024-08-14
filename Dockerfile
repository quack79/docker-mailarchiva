FROM phusion/baseimage:jammy-1.0.4

# Updated to version: 9.0.26
ENV MAILARCHIVA_BASE_URL=https://stimulussoft.b-cdn.net/mailarchiva-server-linux-v9.0.26.tar.gz
ENV MAILARCHIVA_INSTALL_DIR=/opt
ENV MAILARCHIVA_HEAP_SIZE=2048m

# @see http://phusion.github.io/baseimage-docker/
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y expect wget iproute2 vim tzdata

# Get the mailarchiva package and extract it
RUN wget -q -O - $MAILARCHIVA_BASE_URL | tar xzf - -C $MAILARCHIVA_INSTALL_DIR
RUN mv $MAILARCHIVA_INSTALL_DIR/mailarchiva* $MAILARCHIVA_INSTALL_DIR/mailarchiva

# Install mailarchiva - use expect to automate the interactive install
ADD expect-install $MAILARCHIVA_INSTALL_DIR/mailarchiva/expect-install
RUN cd $MAILARCHIVA_INSTALL_DIR/mailarchiva && expect expect-install

# Run mailarchiva on startup 
# @see phusion docs
RUN mkdir -p /etc/my_init.d
ADD run-mailarchiva.sh /etc/my_init.d
RUN chmod +x /etc/my_init.d/run-mailarchiva.sh

# web
EXPOSE 8090
#smtp
EXPOSE 8091
#milter
EXPOSE 8092

# cleanup
RUN apt-get remove -yf expect wget && apt-get autoremove -y 
RUN apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /usr/share/locale/* /usr/share/man/* /usr/share/doc/*
