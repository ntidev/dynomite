FROM debian:stable-slim AS dynomite-builder
RUN apt-get update && apt-get -y install libtool autoconf automake git gcc g++ make libssl-dev
WORKDIR /
RUN git clone https://github.com/Netflix/dynomite.git
WORKDIR /dynomite
RUN autoreconf -fvi
RUN ./configure --enable-debug=yes
RUN make

FROM debian:stable-slim
RUN apt update && apt install libssl-dev -y
WORKDIR /usr/bin
COPY --from=dynomite-builder /dynomite/conf/dynomite.pem .
COPY --from=dynomite-builder /dynomite/src/dynomite .
RUN chmod +x /usr/bin/dynomite
CMD ["/usr/bin/dynomite"]
