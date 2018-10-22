FROM python:2.7

# Create app directory
WORKDIR /usr/src/app

COPY axicli.py ./
COPY utils.py ./
COPY Makefile ./
COPY pyaxidraw pyaxidraw
COPY hashiconf hashiconf

RUN apt-get update

RUN wget -O /usr/src/app/processing.tgz http://download.processing.org/processing-3.4-linux64.tgz 
RUN tar xvf processing.tgz
RUN mv processing-3.4 processing

# Create symbolic link
RUN bash -c "ln -s /usr/src/app/processing/{processing,processing-java} /usr/local/bin/"
