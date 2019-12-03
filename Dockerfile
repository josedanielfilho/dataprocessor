FROM bitwalker/alpine-elixir-phoenix:1.7.0


EXPOSE 4545
ENV PORT=4545

# Cache elixir deps
COPY . .

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.03.1-ce.tgz && \
  tar --strip-components=1 -xvzf docker-17.03.1-ce.tgz -C /usr/local/bin && \
  mix do deps.get, deps.compile
