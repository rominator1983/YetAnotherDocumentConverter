FROM debian:stable


# Install MS fonts?
# => https://github.com/thecodingmachine/gotenberg/blob/e6a5f4b20324047da04f84c2538dec548d99857a/build/base/Dockerfile

RUN apt-get update
RUN apt-get install -y libreoffice 
RUN apt-get install -y unoconv

RUN apt-get install -y python3-pip
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install grpcio
RUN python3 -m pip install grpcio-tools


RUN mkdir /workdir
COPY main.py /
COPY main.sh /

COPY yadc.proto /
RUN python3 -m grpc_tools.protoc -I/ --python_out=. --grpc_python_out=. /yadc.proto


CMD ["/main.sh"]
