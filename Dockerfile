
FROM python:3.11

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libc-dev \
        libjpeg-dev \
        zlib1g-dev \
        libpng-dev

RUN mkdir /workdir

COPY requirements.txt /workdir/
RUN pip install --no-cache-dir -r /workdir/requirements.txt

COPY bugfixer.py /workdir/
COPY entrypoint.sh /workdir/
COPY example/ /workdir/example/

# ENTRYPOINT ["python", "bugfixer.py"]
CMD ["/workdir/entrypoint.sh"]
# ENTRYPOINT ["ls", "/workdir/"]