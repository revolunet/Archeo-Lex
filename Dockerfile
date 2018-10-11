FROM debian:jessie

#
# usage example with local mounts :
#
# docker run \
#    -v $PWD/tarballs:/root/legilibre/tarballs \
#    -v $PWD/sqlite:/root/legilibre/sqlite \
#    -v $PWD/textes:/textes \
#    -v $PWD:/root/legilibre/code/Archeo-Lex \
#    archeo-lex python3 /root/legilibre/code/Archeo-Lex/archeo-lex \
#    -t LEGITEXT000006069414 \
#    --bddlegi=/root/legilibre/sqlite/legilibre.sqlite \
#    --organisation=articles
#
#

ENV PYTHONIOENCODING="UTF-8"
ENV LANG='C.UTF-8'
ENV LC_ALL='C.UTF-8'

ENV LEGILIBRE_DIR=/root/legilibre

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y git && \
    apt-get install -y libarchive13 python3-pip git htop sqlite3 zlib1g-dev && \
    apt-get install -y python3-dev libxml2-dev libxslt1-dev python3-setuptools python3-wheel wget

RUN mkdir -p $LEGILIBRE_DIR && \
    cd $LEGILIBRE_DIR && \
    mkdir -p code tarballs sqlite textes cache

RUN cd $LEGILIBRE_DIR/code && \
    git clone https://github.com/Legilibre/legi.py.git && \
    cd legi.py && \
    pip3 install -r requirements.txt

# use local code for Archeo-Lex
RUN mkdir $LEGILIBRE_DIR/code/Archeo-Lex
WORKDIR $LEGILIBRE_DIR/code/Archeo-Lex
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# delay files copy to use docker cache
COPY . .
