FROM python:3.9.16-bullseye
ENV HOME=/srv
WORKDIR /srv

RUN \
 apt update \
 && apt install -y ca-certificates curl sudo \
 && sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
 && apt update \
 && apt install -y kubectl \
 && apt install python3-pip --yes \
 && pip --no-cache-dir --disable-pip-version-check --quiet install awscli

# Copy entrypoint.sh
COPY entrypoint.sh .
COPY handlers .

# Set permissions on the file.
RUN chmod +x entrypoint.sh

USER nobody

CMD ["/srv/entrypoint.sh"]
