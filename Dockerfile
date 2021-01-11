FROM alpine:latest AS builder

ARG XINETD_VERSION=2.3.15.4
ARG VERSION=3.1.1

RUN apk add build-base autoconf automake libtool pkgconf git
RUN git clone -b ${XINETD_VERSION} https://github.com/openSUSE/xinetd.git
RUN cd xinetd && sh ./autogen.sh && ./configure && make
RUN git clone -b ${VERSION} https://github.com/gophernicus/gophernicus.git
RUN cd gophernicus && ./configure && make

FROM alpine:latest
EXPOSE 70/tcp
VOLUME /var/gopher
RUN mkdir -p /etc/xinetd.d/
RUN mkdir -p /var/gopher
COPY --from=builder /xinetd/xinetd /usr/sbin
COPY --from=builder /gophernicus/src/gophernicus /usr/sbin
COPY --from=builder /gophernicus/gophermap.sample /var/gopher/gophermap
COPY xinetd.conf /etc/xinetd.conf
COPY init.sh /init.sh

CMD ["/init.sh"]
