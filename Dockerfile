FROM alpine:latest

LABEL maintainer="jorijn@jorijn.com"

ARG BUILD_DATE
ARG BUILD_VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ripple/rippled"
LABEL org.label-schema.description="Decentralized cryptocurrency blockchain daemon implementing the XRP Ledger in C++"
LABEL org.label-schema.url="https://ripple.com/xrp"
LABEL org.label-schema.vcs-url="https://github.com/ripple/rippled"
LABEL org.label-schema.vcs-ref="https://github.com/jorijn/docker-rippled-validator"
LABEL org.label-schema.vendor="Ripple"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -v ~/ripple-validator/keystore:/keystore/ -p 51235:51235 -d jorijn/rippled-validator"

RUN apk --update add cmake openssl-dev boost-dev protobuf-dev wget alpine-sdk libexecinfo-dev

RUN mkdir -p /mnt/rippled/build

WORKDIR /mnt
RUN wget https://api.github.com/repos/ripple/rippled/tarball/${BUILD_VERSION} -O rippled.tar.gz -P /mnt/ \
    && tar -xzv -C /mnt/rippled --strip-components=1 -f rippled.tar.gz \
    && cd /mnt/rippled/build \
    && nprocs=$(nproc --all) \
    && cmake .. -Dstatic=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=release \
    && cmake --build . -- -j${nprocs}
