FROM quay.io/kwiksand/cryptocoin-base:latest

ENV VERGE_DATA=/home/verge/.verge

RUN useradd -m verge

USER verge

RUN cd /home/verge && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone https://github.com/vergecurrency/VERGE.git verged && \
    cd /home/verge/verged && \
    git checkout tags/2.1 && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L/usr/local/db4/lib/" CPPFLAGS="-I/usr/local/db4/include/" && \
    #sed -i 's/const CScriptID&/CScriptID/g' src\/rpcrawtransaction.cpp && \
    make 

EXPOSE 20102 21102

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && cp /home/verge/verged/src/VERGEd /usr/bin/verged && chmod 755 /usr/bin/verged

ENTRYPOINT ["/entrypoint.sh"]

CMD ["verged"]
