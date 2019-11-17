try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'Мой проект',
    'author': 'Мое имя',
    'url': 'URL-адрес проекта',
    'download_url': 'Ссылка на скачивание',
    'author_email': 'Мой Email',
    'version': '0.1',
    'install_requires': ['nose'],
    'packages': ['NAME'],
    'scripts': [],
    'name': 'projectname'
}

setup(**config)