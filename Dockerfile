FROM ubuntu:18.04 as build

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    sudo \
    gawk \
    iptables \
    jq \
    pkg-config \
    libaio-dev \
    libcap-dev \
    libprotobuf-dev \
    libprotobuf-c0-dev \
    libnl-3-dev \
    libnet-dev \
    libseccomp2 \
    libseccomp-dev \
    protobuf-c-compiler \
    protobuf-compiler \
    python-minimal \
    uidmap \
    kmod \
    && apt-get clean

ADD . /criu
RUN cd /criu \
    && make install-criu


FROM scratch

COPY --from=build /usr/local/sbin/criu /bin/
COPY --from=build /usr/lib/x86_64-linux-gnu/libprotobuf-c.so.1 /lib/
COPY --from=build /lib/x86_64-linux-gnu/libnl-3.so.200 /lib/
COPY --from=build /usr/lib/x86_64-linux-gnu/libnet.so.1 /lib/
