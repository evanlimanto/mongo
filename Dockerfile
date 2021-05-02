FROM debian:stable

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/evanlimanto/mongo

RUN echo "deb [trusted=yes] http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  scons \
  build-essential

RUN apt-get install -y \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-thread-dev \
  libboost-iostreams-dev

RUN cd mongo \
  && git fetch origin el-build-local \
  && git reset --hard f1d4faf07fad08348485d725efb8fbb36c538006

RUN --mount=type=cache,target=/tmp/scons/cache \
  cd mongo \
  && SCONSFLAGS="-j 9" scons --use-system-boost --disable-warnings-as-errors --cache-dir="/tmp/scons/cache" --cache
