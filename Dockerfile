FROM debian:stable

RUN sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list
RUN apt-get update

# NOTE: Install fonts. Basically copied from https://github.com/thecodingmachine/gotenberg/blob/master/build/base/Dockerfile
# TODO: add noto-emoji as in https://github.com/gotenberg/gotenberg/blob/main/build/Dockerfile:
# curl -Ls "https://github.com/googlefonts/noto-emoji/raw/$NOTO_COLOR_EMOJI_VERSION/fonts/NotoColorEmoji.ttf" -o /usr/local/share/fonts/NotoColorEmoji.ttf &&\

RUN apt-get install -y msttcorefonts
RUN apt-get install --no-install-recommends -y culmus
RUN apt-get install --no-install-recommends -y fonts-beng
RUN apt-get install --no-install-recommends -y fonts-hosny-amiri
RUN apt-get install --no-install-recommends -y fonts-lklug-sinhala
RUN apt-get install --no-install-recommends -y fonts-lohit-guru
RUN apt-get install --no-install-recommends -y fonts-lohit-knda
RUN apt-get install --no-install-recommends -y fonts-samyak-gujr
RUN apt-get install --no-install-recommends -y fonts-samyak-mlym
RUN apt-get install --no-install-recommends -y fonts-samyak-taml
RUN apt-get install --no-install-recommends -y fonts-sarai
RUN apt-get install --no-install-recommends -y fonts-sil-abyssinica
RUN apt-get install --no-install-recommends -y fonts-sil-padauk
RUN apt-get install --no-install-recommends -y fonts-telu
RUN apt-get install --no-install-recommends -y fonts-thai-tlwg
RUN apt-get install --no-install-recommends -y ttf-wqy-zenhei
RUN apt-get install --no-install-recommends -y fonts-arphic-uming
RUN apt-get install --no-install-recommends -y fonts-ipafont-mincho
RUN apt-get install --no-install-recommends -y fonts-ipafont-gothic
RUN apt-get install --no-install-recommends -y fonts-unfonts-core
# LibreOffice recommends.
RUN apt-get install --no-install-recommends -y fonts-crosextra-caladea
RUN apt-get install --no-install-recommends -y fonts-crosextra-carlito
RUN apt-get install --no-install-recommends -y fonts-dejavu
RUN apt-get install --no-install-recommends -y fonts-dejavu-extra
RUN apt-get install --no-install-recommends -y fonts-liberation
RUN apt-get install --no-install-recommends -y fonts-liberation2
RUN apt-get install --no-install-recommends -y fonts-linuxlibertine
RUN apt-get install --no-install-recommends -y fonts-noto-cjk
RUN apt-get install --no-install-recommends -y fonts-noto-core
RUN apt-get install --no-install-recommends -y fonts-noto-mono
RUN apt-get install --no-install-recommends -y fonts-noto-ui-core
RUN apt-get install --no-install-recommends -y fonts-sil-gentium
RUN apt-get install --no-install-recommends -y fonts-sil-gentium-basic 

RUN apt-get install -y libreoffice
RUN apt-get install -y python3-pip
RUN apt-get install -y libreoffice-script-provider-python
RUN apt-get install -y mc
RUN apt-get install -y unoconv
RUN apt-get install -y tini

# TODO: https://docs.moodle.org/311/en/mod/assign/feedback/editpdf/testunoconv/initd states
#   that there should be a cron job starting the listener too.
#   Test, if this is needed by checking for the listener in the rendering step.
COPY unoconvListenerInitScript.sh /
RUN chmod +x unoconvListenerInitScript.sh
RUN cp /unoconvListenerInitScript.sh /etc/init.d/unoconvd

RUN update-rc.d unoconvd defaults
RUN /etc/init.d/unoconvd start

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install grpcio
RUN python3 -m pip install grpcio-tools

COPY yadc.proto /
RUN python3 -m grpc_tools.protoc -I/ --python_out=. --grpc_python_out=. /yadc.proto

COPY main.sh /
RUN chmod +x /main.sh

COPY main.py /
RUN chmod +x /main.py

# TODO: for some reason CTRL+C does not get passed through and exit the container when starting attached when running the dockerhub-image locally
ENTRYPOINT ["/usr/bin/tini", "--", "/main.sh"]