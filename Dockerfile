FROM debian:stable

# TODO: Install MS fonts as is done in gotenberg container
# => https://github.com/thecodingmachine/gotenberg/blob/e6a5f4b20324047da04f84c2538dec548d99857a/build/base/Dockerfile
# there are further fonts in the gotenberg repository laying around

RUN apt-get update
RUN apt-get install -y libreoffice 
RUN apt-get install -y python3-pip
RUN apt-get install -y libreoffice-script-provider-python
RUN apt-get install -y mc
RUN apt-get install -y unoconv

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install grpcio
RUN python3 -m pip install grpcio-tools

COPY yadc.proto /
RUN python3 -m grpc_tools.protoc -I/ --python_out=. --grpc_python_out=. /yadc.proto

COPY main.sh /
COPY main.py /

CMD ["/main.sh"]