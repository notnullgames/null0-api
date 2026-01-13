FROM konsumer/null0-cart-c:latest

COPY docker/build_nim.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

COPY generated/carts/nim/null0.nim /usr/local/include

RUN apt-get update && apt-get install -y nim && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["build_nim.sh"]