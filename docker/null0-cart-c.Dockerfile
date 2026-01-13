FROM ghcr.io/webassembly/wasi-sdk:latest

COPY headers/null0.h /usr/local/include/

COPY zipcart.sh /usr/local/bin/
COPY build_c.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

RUN apt-get update && apt-get install -y zip && rm -rf /var/lib/apt/lists/*

VOLUME /src
VOLUME /out

ENTRYPOINT ["/usr/local/bin/build_c.sh"]