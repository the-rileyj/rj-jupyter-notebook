FROM golang:alpine AS buildenv

# Add gcc and musl-dev for any cgo dependencies, and
# git for getting dependencies residing on github
RUN apk add --no-cache gcc git musl-dev

RUN echo TEST

WORKDIR /go/src/github.com/the-rileyj/rjin

RUN git clone https://github.com/the-rileyj/rjin .

# Get dependencies locally, but don't install
RUN go get -d ./...

# Compile program statically linked with local dependencies
RUN env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags '-extldflags "-static"' -a -v -o rjin

FROM jupyter/tensorflow-notebook

EXPOSE 80

RUN PYTHONPATH $PYTHONPATH:/home/jovyan/work/Utils/

USER root

COPY ./dependency-lists/apt-get-dependencies.txt .

RUN sudo apt-get update && \
    sudo apt-get install -y $(grep -E "^\s+" apt-get-dependencies.txt  | tr "\n" " ") && \
    curl https://raw.githubusercontent.com/the-rileyj/InstallVimWorkSpace/master/VimInstaller.sh -s | bash

COPY --from=buildenv /go/src/github.com/the-rileyj/rjin/rjin /usr/local/bin

RUN chmod +x /usr/local/bin/rjin

ENV RJIN_DEPENDENCIES /home/jovyan/dependency-lists/

USER jovyan

COPY ./dependency-lists/python-dependencies.txt .

RUN pip install --no-cache-dir -r python-dependencies.txt

# This is to prevent any collisions when we attach the requirements file
# in the repo for watching changes
RUN rm python-dependencies.txt && rm apt-get-dependencies.txt

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py
