# pull official base image
FROM python:3.9.0-slim-buster

COPY . /usr/src/app

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# new
# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat gcc postgresql libpq-dev \
  && apt-get clean


# install requirements
RUN pip install -r requirements.txt

RUN chmod +x /usr/src/app/entrypoint.sh

