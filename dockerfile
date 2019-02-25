FROM golang:alpine AS buildenv

# Add gcc and musl-dev for any cgo dependencies, and
# git for getting dependencies residing on github
RUN apk add --no-cache gcc git musl-dev

WORKDIR /go/src/github.com/the-rileyj/pipr

RUN git clone https://github.com/the-rileyj/pipr .

# Get dependencies locally, but don't install
RUN go get -d ./...

ENV GOOS linux
ENV GOARCH amd64

# Compile program with local dependencies
RUN go build -o pipr

FROM jupyter/tensorflow-notebook

EXPOSE 80

ENV PYTHONPATH "$PYTHONPATH:/home/jovyan/work/Utils/"

USER root

RUN sudo apt-get update && \
    sudo apt-get install -y vim curl && \
    curl https://raw.githubusercontent.com/the-rileyj/InstallVimWorkSpace/master/VimInstaller.sh -s | bash

COPY --from=buildenv /go/src/github.com/the-rileyj/pipr/pipr /usr/local/bin

RUN chmod +x /usr/local/bin/pipr

USER jovyan

COPY requirements.txt .

RUN pip install -r requirements.txt

# This is to prevent any collisions when we attach the requirements file
# in the repo for watching changes
RUN rm requirements.txt

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py
