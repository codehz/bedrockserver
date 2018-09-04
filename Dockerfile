FROM codehz/mcpe-sdk as SDK
FROM archlinux/base as BUILDER
COPY --from=SDK /data /data
RUN echo [multilib] >> /etc/pacman.conf && \
    echo Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf
RUN pacman -Sy --noconfirm --needed nim nimble base-devel cmake lib32-gcc-libs lib32-glibc lib32-gmp lib32-libffi lib32-libgcrypt lib32-libgpg-error lib32-libltdl lib32-libunistring lib32-systemd lib32-xz git && \
  nimble install -y https://github.com/codehz/nimake
COPY . /build
WORKDIR /build
RUN echo >> /etc/nim.cfg && \
  echo i386.android.gcc.cpp.exe = '"/data/bin/i686-linux-android-g++"' >> /etc/nim.cfg && \
  echo i386.android.gcc.cpp.linkerexe = '"/data/bin/i686-linux-android-g++"' >> /etc/nim.cfg && \
  mkdir bin && \
  PATH=$PATH:/data/sdk/bin /root/.nimble/bin/nimake build -v 5 /root/.nimble/bin/nimake build -v 1

FROM archlinux/base
RUN pacman -Sy --noconfirm --needed lib32-gcc-libs lib32-glibc lib32-gmp lib32-libffi lib32-libgcrypt lib32-libgpg-error lib32-libltdl lib32-libunistring lib32-systemd lib32-xz
COPY --from=BUILDER /build/bin/bedrockserver /data/bin/
