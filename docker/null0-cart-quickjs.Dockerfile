FROM konsumer/null0-cart-c:latest

COPY docker/zipcart.sh /usr/local/bin/
COPY docker/build_quickjs.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

COPY docker/quickjs-cart /usr/local/include/quickjs/

# build cart wasm & wipe source
COPY generated/carts/c/main_js.c /usr/local/include/quickjs/null0_main.c
RUN cd /usr/local/include/quickjs/ && \
  clang -O3 -Wl,--initial-memory=1310720 -Wl,--max-memory=13107200 -D_WASI_EMULATED_SIGNAL -DCONFIG_VERSION=wasi -DCONFIG_BIGNUM=y -o /usr/local/lib/main.wasm -I /usr/local/include null0_main.c libunicode.c cutils.c libbf.c libregexp.c quickjs.c quickjs-libc.c qjscalc.c && \
  rm -rf /usr/local/include/quickjs

ENTRYPOINT ["/usr/local/bin/build_quickjs.sh"]