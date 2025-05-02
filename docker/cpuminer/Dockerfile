#
# Dockerfile for cpuminer
# usage: docker run creack/cpuminer --url xxxx --user xxxx --pass xxxx
# ex: docker run creack/cpuminer --url stratum+tcp://ltc.pool.com:80 --user creack.worker1 --pass abcdef


FROM ubuntu as base
RUN apt-get update -qq && \
    apt-get install -qqy libcurl4-openssl-dev

FROM base as build
RUN apt-get update -qq && \
    apt-get install -qqy automake git make gcc

RUN git clone https://github.com/pooler/cpuminer

RUN cd cpuminer && \
    ./autogen.sh && \
    ./configure CFLAGS="-O3" && \
    make

FROM base as result
WORKDIR /cpuminer
COPY --from=build /cpuminer/minerd /cpuminer/minerd

ENTRYPOINT ["./minerd"]