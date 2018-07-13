FROM codehz/mcpe-sdk as SDK
FROM codehz/mcpe-prebuilt as PREBUILT
FROM nimlang/nim as BUILDER
COPY --from=SDK /data /data
RUN apt-get install -y cmake g++-multilib
RUN nimble install -y https://github.com/codehz/nimake
COPY . /build
WORKDIR /build
RUN echo i386.android.gcc.cpp.exe = \\"/data/bin/i686-linux-android-g++\\" >> /etc/nim.cfg && \
  echo i386.android.gcc.cpp.linkerexe = \\"/data/bin/i686-linux-android-g++\\" >> /etc/nim.cfg && \
  mkdir bin && \
  PATH=$PATH:/data/bin /root/.nimble/bin/nimake build -v 1 && \
  cp /build/LICENSE /build/bin/LICENSE
COPY --from=PREBUILT / /build/bin

FROM scratch
COPY --from=BUILDER /build/bin/* /