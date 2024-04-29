FROM almalinux:8 AS base

# RUN echo "[goreleaser]" > /etc/yum.repos.d/goreleaser.repo && \
#     echo "name=GoReleaser" >> /etc/yum.repos.d/goreleaser.repo && \
#     echo "baseurl=https://repo.goreleaser.com/yum/" >> /etc/yum.repos.d/goreleaser.repo && \
#     echo "enabled=1" >> /etc/yum.repos.d/goreleaser.repo && \
#     echo "gpgcheck=0" >> /etc/yum.repos.d/goreleaser.repo

RUN dnf install -y epel-release dnf-plugins-core git && \
    dnf update -y && \
    dnf config-manager --set-enabled 'powertools'
    # curl -LsS "https://r.mariadb.com/downloads/mariadb_repo_setup" | bash -s -- --os-type=rhel --os-version=8 --mariadb-server-version="mariadb-10.5" && \
    # dnf install -y cmake \
    #     gcc \
    #     gcc-c++ \
    #     gdb \
    #     gettext \
    #     git \
    #     ninja-build \
    #     openssh-server \
    #     MariaDB-devel \
    #     MariaDB-shared \
    #     MariaDB-client \
    #     MariaDB-compat \
    #     MariaDB-common \
    #     MariaDB-server \
    #     gnutls-devel \
    #     libgcrypt-devel \
    #     lua-devel \
    #     make \
    #     perl-ExtUtils-Embed.noarch \
    #     python38 \
    #     python38-pip \
    #     perl-Thread-Queue \
    #     redhat-lsb \
    #     rrdtool-devel \
    #     selinux-policy-devel \
    #     yum-utils \
    #     perl-interpreter \
    #     zstd \
    #     nfpm \
    #     openssl-devel \
    #     libssh2-devel \
    #     libcurl-devel \
    #     zlib-devel \
    #     sudo \
    #     protobuf-devel && \
    #     dnf update libarchive

RUN git clone -b dev-23.10.x https://github.com/centreon/centreon-collect

WORKDIR /centreon-collect

RUN ./cmake.sh -GNinja
# pip3 install conan==1.62.0 --prefix=/usr --upgrade && \
    # conan install . -s compiler.cppstd=17 -s compiler.libcxx=libstdc++11 --build=missing

# RUN cmake3 \
# -G "Ninja" \
# -DDEBUG_ROBOT=OFF \
# -DWITH_TESTING=OFF \
# -DWITH_BENCH=ON \
# -DWITH_MODULE_SIMU=OFF \
# -DCMAKE_INSTALL_PREFIX=/usr \
# -DWITH_STARTUP_SCRIPT=systemd \
# -DWITH_ENGINE_LOGROTATE_SCRIPT=ON \
# -DWITH_USER_BROKER=centreon-broker \
# -DWITH_GROUP_BROKER=centreon-broker \
# -DWITH_USER_ENGINE=centreon-engine \
# -DWITH_GROUP_ENGINE=centreon-engine \
# -DWITH_VAR_DIR=/var/log/centreon-engine \
# -DWITH_DAEMONS=ON \
# -DWITH_CREATE_FILES=OFF \
# -DWITH_CONFIG_FILES=ON \
# -DCMAKE_BUILD_TYPE=RelWithDebInfo \
# -DNG=ON \
# .

RUN groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker

WORKDIR /centreon-collect/build
RUN ninja && \
    # bash ./packaging/scripts/centreon-engine-daemon-preinstall.sh && \
    ninja install
    # bash ./packaging/scripts/centreon-engine-daemon-postinstall.sh

FROM almalinux:8 AS centengine

RUN groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker


# COPY --from=base /usr/include/centreon-clib/ /usr/include/centreon-clib/
COPY --from=base /usr/lib64/libcentreon_clib.so /usr/lib64/

COPY --from=base /usr/share/centreon/lib/centreon-broker/*.so /usr/share/centreon/lib/centreon-broker/
COPY --from=base /usr/lib64/nagios/cbmod.so /usr/lib64/nagios/
# COPY --from=base /usr/include/centreon-broker /usr/include/centreon-broker
# COPY --from=base /usr/bin/ccc /usr/bin/

# COPY --from=base /usr/include/centreon-engine /usr/include/centreon-engine
COPY --from=base /usr/lib64/centreon-engine/*.so /usr/lib64/centreon-engine/
# COPY --from=base /usr/sbin/centengine_bench_passive /usr/sbin/
COPY --from=base /usr/sbin/centengine /usr/sbin/
COPY --from=base /usr/sbin/centenginestats /usr/sbin/
COPY --from=base /etc/centreon-engine/ /etc/centreon-engine/
# COPY --from=base /usr/include/centreon-engine/ /usr/include/centreon-engine/


