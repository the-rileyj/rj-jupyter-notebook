FROM jupyter/tensorflow-notebook

EXPOSE 80

ENV PATH "$PATH:/home/jovyan/Utils/"

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py