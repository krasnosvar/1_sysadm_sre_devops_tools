FROM python:3.11.9-slim-bullseye

WORKDIR /python-docker

# COPY requirements.txt requirements.txt
RUN pip3 install flask simplejson

COPY test_headers.py test_headers.py

CMD [ "python3", "-m" , "flask", "--app", "test_headers", "run", "--host=0.0.0.0"]
