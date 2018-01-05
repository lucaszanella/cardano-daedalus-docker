FROM ubuntu:16.04

#Node (cardano-sl) installation

RUN apt-get update &&\ 
    apt-get install -y git curl bzip2 &&\
    useradd -ms /bin/bash cardano &&\
    mkdir -m 0755 /nix &&\
    chown cardano /nix &&\
    mkdir -p /etc/nix &&\
    echo binary-caches = https://cache.nixos.org https://hydra.iohk.io > /etc/nix/nix.conf &&\
    echo binary-caches-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= >> /etc/nix/nix.conf &&\
    su - cardano -c 'git clone https://github.com/input-output-hk/cardano-sl.git /home/cardano/cardano-sl'
    
USER cardano
ENV USER cardano
RUN curl https://nixos.org/nix/install | sh

WORKDIR /home/cardano/cardano-sl
RUN git checkout cardano-sl-1.0
RUN . /home/cardano/.nix-profile/etc/profile.d/nix.sh &&\
    nix-build -A cardano-sl-static --cores 0 --max-jobs 2 --no-build-output --out-link cardano-sl-1.0
RUN . /home/cardano/.nix-profile/etc/profile.d/nix.sh &&\
    nix-build release.nix -A connect.mainnetWallet -o connect-to-mainnet

#Wallet (daedalus) installation

USER root
RUN apt-get update &&\
    apt-get install -y git curl build-essential libgtk2.0.0 libasound2 \
                       libnotify-bin libgconf-2-4 libnss3 libxss1 &&\
    curl -sL https://deb.nodesource.com/setup_6.x | bash &&\
    apt-get install -y nodejs
USER cardano
WORKDIR /home/cardano
RUN git clone https://github.com/input-output-hk/daedalus.git &&\
    cd daedalus &&\
    npm install && npm run-script package
RUN mkdir daedalus/tls/ca && cp daedalus/tls/ca.crt daedalus/tls/ca
ENTRYPOINT cd daedalus && npm start & cd cardano-sl && ./connect-to-mainnet
