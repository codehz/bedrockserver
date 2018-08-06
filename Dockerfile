FROM codehz/mcpe-sdk as SDK
FROM archlinux/base as BUILDER
COPY --from=SDK /data /data
RUN pacman -Sy nimble base-devel cmake && \
  nimble install -y https://github.com/codehz/nimake
COPY . /build
WORKDIR /build
RUN echo i386.android.gcc.cpp.exe = \\"/data/bin/i686-linux-android-g++\\" >> /etc/nim.cfg && \
  echo i386.android.gcc.cpp.linkerexe = \\"/data/bin/i686-linux-android-g++\\" >> /etc/nim.cfg && \
  mkdir bin && \
  PATH=$PATH:/data/bin /root/.nimble/bin/nimake build -v 1

FROM archlinux/base
COPY --from=BUILDER /build/bin/* /usr/bin
