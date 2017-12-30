FROM ubuntu:16.04

RUN apt-get update &&\
    apt-get install -y git curl build-essential libgtk2.0.0 libasound2 \
                       libnotify-bin libgconf-2-4 libnss3 libxss1 &&\
    curl -sL https://deb.nodesource.com/setup_6.x | bash &&\
    apt-get install -y nodejs &&\
    useradd -ms /bin/bash daedalus
RUN su - daedalus -c 'git clone https://github.com/input-output-hk/daedalus.git /home/daedalus/daedalus &&\
                      cd /home/daedalus/daedalus &&\
                      git checkout a267ae05daaf3947fe679eac56d1257a8775b27b &&\
                      curl -o daedalus-bridge.tar.xz "https://s3.eu-central-1.amazonaws.com/cardano-sl-travis/daedalus-bridge-linux-master.tar.xz" &&\
                      mkdir -p node_modules/daedalus-client-api/ &&\
                      tar xJf daedalus-bridge.tar.xz --strip-components=1 -C node_modules/daedalus-client-api/ &&\
                      rm      daedalus-bridge.tar.xz &&\
                      npm install && npm run-script package'
USER daedalus
WORKDIR /home/daedalus/daedalus
USER daedalus
RUN mkdir tls/ca && cp tls/ca.crt tls/ca
CMD npm start
