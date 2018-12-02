FROM python:3

#
# usage example with local mounts :
#
# docker run \
#    -v $PWD/tarballs:/legilibre/tarballs \
#    -v $PWD/sqlite:/legilibre/sqlite \
#    -v $PWD/textes:/textes \
#    -v $PWD:/legilibre/code/Archeo-Lex \
#    archeo-lex python3 /legilibre/code/Archeo-Lex/archeo-lex \
#    -t LEGITEXT000006069414 \
#    --bddlegi=/legilibre/sqlite/legilibre.sqlite \
#    --organisation=articles
#
#

ENV PYTHONIOENCODING="UTF-8"
ENV LANG='C.UTF-8'
ENV LC_ALL='C.UTF-8'

ENV LEGILIBRE_DIR=/legilibre

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get dist-upgrade -y && \
    apt-get install -y libarchive13 python3-pip git htop sqlite3 locales

RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=fr_FR.UTF-8

ENV LANG fr_FR.UTF-8
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
