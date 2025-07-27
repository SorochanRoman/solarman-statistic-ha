ARG BUILD_FROM
FROM $BUILD_FROM

# Install Python and required system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev

# Copy requirements and install Python dependencies
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r requirements.txt

# Remove build dependencies to reduce image size
RUN apk del gcc musl-dev python3-dev libffi-dev openssl-dev

# Copy application files
COPY app.py /
COPY templates/ /templates/
COPY run.sh /
RUN chmod a+x /run.sh

# Expose port for web interface
EXPOSE 8099

# Set the default command
CMD [ "/run.sh" ]