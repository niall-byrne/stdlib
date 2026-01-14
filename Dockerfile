FROM ubuntu:latest

ARG UNAME1=user1
ARG UID1=1000
ARG GID1=1000

ARG UNAME2=user2
ARG UID2=2001
ARG GID2=2001

ENV PATH="${PATH}:/work/dist"

RUN \
  apt-get update \
  && apt-get install -y bash-completion ca-certificates curl elfutils gettext git mandoc sudo unzip vim \
  && rm -rf /var/cache/apt/lists

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN groupadd -g $GID1 -o $UNAME1 \
    && useradd -m -u $UID1 -g $UNAME1 -s /bin/bash $UNAME1 \
    && usermod -aG sudo $UNAME1

RUN groupadd -g $GID2 -o $UNAME2 \
    && useradd -m -u $UID2 -g $UNAME2 -s /bin/bash $UNAME2 \
    && usermod -aG sudo $UNAME2

# Install bash_unit
RUN \
  curl \
    --silent \
    --retry 5 \
    --retry-delay 5 \
    --fail \
    "https://raw.githubusercontent.com/bash-unit/bash_unit/master/install.sh" | bash \
  && mv bash_unit /usr/local/bin

# Install shdoc
RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y make gawk \
  && rm -rf /var/cache/apt/lists \
  && cd "$(mktemp -d)" \
  && git clone --recursive https://github.com/reconquest/shdoc \
  && cd shdoc \
  && make install \
  && rm -rf "${PWD}"

# Install kcov
COPY --from=kcov/kcov:latest /usr/local/bin/kcov* /usr/local/bin/
COPY --from=kcov/kcov:latest /usr/local/share/doc/kcov /usr/local/share/doc/kcov

WORKDIR /work

USER $UNAME1
