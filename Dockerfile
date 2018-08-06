FROM codehz/mcpe-sdk as SDK
FROM nimlang/nim as BUILDER
COPY --from=SDK /data /data
RUN apt-get update && \
  apt-get install -y cmake g++-multilib && \
  nimble install -y https://github.com/codehz/nimake
COPY . /build
WORKDIR /build
RUN echo i386.android.gcc.cpp.exe = \\"/data/bin/i686-linux-android-g++\\" >> /etc/nim.cfg && \
  echo i386.android.gcc.cpp.linkerexe = \\"/data/bin/i686-linux-android-g++\\" >> /etc/nim.cfg && \
  mkdir bin && \
  PATH=$PATH:/data/bin /root/.nimble/bin/nimake build -v 1 && \
  cp /build/LICENSE /build/bin/LICENSE && \
  ldd bedrockserver | cut -d" " -f3 | xargs -I '{}' cp '{}' /build/bin

FROM scratch
COPY --from=BUILDER /build/bin/* /
