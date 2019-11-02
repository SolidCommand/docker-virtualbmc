ARG BASE_IMAGE=alpine:latest
FROM ${BASE_IMAGE}

# Install deps.
ARG VERSION
RUN set -xe; \
    apk add --update  --no-cache --virtual .runtime-deps \
        ca-certificates \
        libffi \
        libvirt \
        libzmq \
        openssh-client \
        openssl \
        tzdata; \
    apk add --no-cache --virtual .build-deps \
        g++ \
        gcc \
        libffi-dev \
        libvirt-dev \
        musl-dev \
        openssl-dev \
        zeromq-dev; \
    pip install --no-cache-dir "virtualbmc==${VERSION}"; \
    apk del .build-deps;

# Create our group & user.
RUN set -xe; \
    addgroup -g 1000 -S virtualbmc; \
    adduser -u 1000 -S -h /virtualbmc -s /bin/sh -G virtualbmc virtualbmc; \
    mkdir -p /virtualbmc/.ssh; \
    echo -e "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null\n" > /virtualbmc/.ssh/config; \
    chown -R virtualbmc:virtualbmc /virtualbmc/.ssh; \
    chmod 0700 /virtualbmc/.ssh; \
    chmod 0644 /virtualbmc/.ssh/config;

# Copy our entrypoint into the container.
COPY ./runtime-assets /

# Build arguments.
ARG VCS_REF
ARG BUILD_DATE

# Labels / Metadata.
LABEL \
    org.opencontainers.image.authors="James Brink <brink.james@gmail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.description="VirtualBMC ${VERSION}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.source="https://github.com/SolidCommand/docker-virtualbmc" \
    org.opencontainers.image.title="virtualbmc" \
    org.opencontainers.image.vendor="Solid Command" \
    org.opencontainers.image.version="${VERSION}"

# Setup our environment variables.
ENV \
    PATH="/usr/local/bin:$PATH" \
    VERSION="${VERSION}"

# Drop down to our unprivileged user.
USER virtualbmc

# Set our working directory.
WORKDIR /virtualbmc

# Set the entrypoint.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set the default command
CMD ["vbmcd"]