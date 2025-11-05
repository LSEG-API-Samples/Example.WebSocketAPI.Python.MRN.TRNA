#Build stage 
FROM docker.io/python:3.11.14-slim AS builder 

LABEL maintainer="LSEG Developer Relations Team"

#Copy requirements.txt
COPY requirements.txt .

# install dependencies to the local user directory (eg. /root/.local)
RUN pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org --no-cache-dir --user -r requirements.txt

# Run stage
#FROM python:3.8.11-alpine3.14
FROM docker.io/python:3.11-alpine3.21
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