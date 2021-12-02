#Build stage 
FROM python:3.8.12-alpine3.15 AS builder 
#FROM python:3.8.12-slim-buster AS builder

LABEL maintainer="Wasin Waeosri <wasin.waeosri@lseg.com>"

# Install build-base + gcc + musl-dev, for alpine3 only
RUN apk update && apk add --no-cache build-base gcc musl-dev 
#Copy requirements.txt
COPY requirements.txt .

# install dependencies to the local user directory (eg. /root/.local)
RUN pip install --user -r requirements.txt

# Run stage
#FROM python:3.8.11-alpine3.14
FROM python:3.8.12-alpine3.15
WORKDIR /app

# Update PATH environment variable + set Python buffer to make Docker print every message instantly.
ENV PATH=/root/.local:$PATH \
    PYTHONUNBUFFERED=1

# copy only the dependencies installation from the 1st stage image
COPY --from=builder /root/.local /root/.local
# For RTDS
##COPY console/mrn_trna_console_app.py .
# For RTO
COPY console/mrn_trna_console_rto.py .

# Run Python for RTDS
##ENTRYPOINT ["python", "./mrn_trna_console_app.py"]

#Run Python for RTO
ENTRYPOINT ["python", "./mrn_trna_console_rto.py"]