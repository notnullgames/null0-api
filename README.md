The idea here is a central place for some example-carts for [null0](https://github.com/notnullgames/null0), and the headers used to make them. I also use this as a place to store docker containers for building them.

- You will need docker installed to use these, which greatly simplifies your setup.
- volume-mount your cart in `/src`
- volume-mount your output-dir in `/out`
- the first param is the name of the cart
- put any filenames you don't want packaged in your cart, in `.cartignore` (.gitignore syntax)

### available containers

- `konsumer/null0-cart-c`
- `konsumer/null0-cart-quickjs`
- `konsumer/null0-cart-nelua`
- `konsumer/null0-cart-assemblyscript`
- `konsumer/null0-cart-nim`
- `konsumer/null0-cart-zig`
- `konsumer/null0-cart-rust`
- `konsumer/null0-cart-py2wasm`

### example usage

```sh
# build a cart from main.c (and assets) in current dir, output to ~/Desktop/tester.null0
docker run -it -v .:/src -v ~/Desktop:/out konsumer/null0-cart-c tester
```

## usage in Github CI

you can easily use it in Github Actions:

```yml
# github/workflows/publish.yml

on: push

jobs:
  build:
    name: Build & Publish Cart
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Build C Cart
        run: docker run -v .:/src -v .:/out konsumer/null0-cart-c tester
      - name: Upload cart artifact
        uses: actions/upload-artifact@v4
        with:
          name: tester
          path: tester.null0
```

## development

This is really just notes for me:

```sh
# 1-time setup
docker buildx create --name multiarch --driver docker-container --bootstrap
docker buildx use multiarch
docker run --privileged --rm tonistiigi/binfmt --install all

# generate headers (needed on API change)
npm i
npm run generate

# build & publish (needed on API change)
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-c docker -f docker/null0-cart-c.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-quickjs docker -f docker/null0-cart-quickjs.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-nelua docker -f docker/null0-cart-nelua.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-assemblyscript docker -f docker/null0-cart-assemblyscript.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-nim docker -f docker/null0-cart-nim.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-zig docker -f docker/null0-cart-zig.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-rust docker -f docker/null0-cart-rust.Dockerfile
docker build  --push --platform linux/amd64,linux/arm64 -t konsumer/null0-cart-py2wasm docker -f docker/null0-cart-py2wasm.Dockerfile

# test
docker run -it -v ./carts/c/colorbars:/src -v ./out:/out konsumer/null0-cart-c colorbars
```
