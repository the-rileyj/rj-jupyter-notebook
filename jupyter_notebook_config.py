c = get_config()

# inline figures for Matplotlib
c.IPKernelApp.pylab = 'inline'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.token = ''

# Place where I will be mounting the volume with my notebooks to
c.NotebookApp.notebook_dir = '/home/jovyan/work'

# Run Jupyter as root user
c.NotebookApp.allow_root = True

# Setting up Jupyter base URL (so that requests from NGINX can be handled properly)
c.NotebookApp.base_url = '/jupyter/'

# Allow Jupyter to trust xheaders because they will be set from NGINX
c.NotebookApp.trust_xheaders = True

c.NotebookApp.tornado_settings = {
    'headers': {
        'Content-Security-Policy': "frame-ancestors 'self' http://* https://*",
    }
}
