FROM ubuntu:20.04 AS build-env

RUN apt-get update 
RUN apt-get install -y curl \
                    git \
                    unzip
RUN apt-get clean

ENV HTTPS_PROXY proxydc.novomundo.com.br:3128
ENV HTTP_PROXY proxydc.novomundo.com.br:3128
ENV NO_PROXY localhost,127.0.0.1

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web


# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Stage 2 - Create the run-time image
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html