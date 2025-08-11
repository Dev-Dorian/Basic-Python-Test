FROM python:alpine3.21

COPY src/main.py  /src/main.py
COPY src/requirements.txt /src/requirements.txt 

WORKDIR /src

CMD [ "python","main.py" ]
