FROM debian:stable


# Install MS fonts?
# => https://github.com/thecodingmachine/gotenberg/blob/e6a5f4b20324047da04f84c2538dec548d99857a/build/base/Dockerfile

RUN apt-get update
RUN apt-get install -y libreoffice 
RUN apt-get install -y unoconv

RUN mkdir /workdir
#WORKDIR /workdir
COPY main.py /
COPY main.sh /

#CMD /workdir/main.py
#ENTRYPOINT [ "/usr/bin/python", "/workdir/main.py" ]
#CMD /bin/sh
CMD ["/main.sh"]
