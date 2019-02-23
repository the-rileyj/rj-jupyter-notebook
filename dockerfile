FROM jupyter/tensorflow-notebook

EXPOSE 80

ENV PYTHONPATH "$PYTHONPATH:/home/jovyan/work/Utils/"

USER root

RUN sudo apt-get update && \
    sudo apt-get install -y vim curl && \
    curl https://raw.githubusercontent.com/the-rileyj/InstallVimWorkSpace/master/VimInstaller.sh -s | bash

USER jovyan

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py
