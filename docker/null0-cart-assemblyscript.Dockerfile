FROM node:latest

COPY docker/zipcart.sh /usr/local/bin/
COPY docker/build_assemblyscript.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

RUN apt-get update && apt-get install -y zip && rm -rf /var/lib/apt/lists/*

VOLUME /src
VOLUME /out
WORKDIR /src

COPY generated/carts/as/null0.ts /usr/local/include/

RUN npm i -g assemblyscript

ENTRYPOINT ["build_assemblyscript.sh"]