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
  cp /usr/lib32/libc.so.6 /build/bin && \
  cp /usr/lib32/libm.so.6 /build/bin && \
  cp /usr/lib32/libpthread.so.0 /build/bin && \
  cp /usr/lib32/libdl.so.2 /build/bin && \
  cp /usr/lib32/libstdc++.so.6  /build/bin && \
  cp /usr/lib32/libgcc_s.so.1 /build/bin

FROM scratch
COPY --from=BUILDER /build/bin/* /
