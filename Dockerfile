# Container image that runs your code
FROM alpine:3.10

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint-test.sh`)
ENTRYPOINT ["/entrypoint-test.sh"]


# FROM python:3.11

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         gcc \
#         libc-dev \
#         libjpeg-dev \
#         zlib1g-dev \
#         libpng-dev

# WORKDIR /app

# COPY requirements.txt /app/
# RUN pip install --no-cache-dir -r requirements.txt

# COPY bugfixer.py /app/
# COPY example/ /app/example/

# ENTRYPOINT ["python", "bugfixer.py"]
