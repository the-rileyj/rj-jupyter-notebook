FROM jupyter/tensorflow-notebook

EXPOSE 80

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py