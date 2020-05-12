# Start from whatever image you are using
FROM python:3-alpine

# Install the packages required for watchman to work properly:
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update \
  && apk upgrade \
  && apk add --no-cache libcrypto1.1 libgcc libstdc++

# Copy the watchman executable binary directly from our image:
COPY --from=icalialabs/watchman:alpine3.9 /usr/local/bin/watchman* /usr/local/bin/

# Create the watchman STATEDIR directory:
RUN mkdir -p /usr/local/var/run/watchman \
  && touch /usr/local/var/run/watchman/.not-empty

# (Optional) Copy the compiled watchman documentation:
COPY --from=icalialabs/watchman:alpine3.9 /usr/local/share/doc/watchman* /usr/local/share/doc/

# Continue with the rest of your Dockerfile...
ENTRYPOINT ["/bin/sh"]
