FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake python3
RUN apt-get install -y python3-pip python-is-python3
RUN pip install conan==1.60.1

RUN git clone --depth 1 --branch "main" "https://github.com/seelabs/xbridge_witness.git" source
RUN apt-get install -y software-properties-common && apt-get update
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt-get install -y gcc-11 g++-11 && \
    update-alternatives --remove-all cpp && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 --slave /usr/bin/g++ g++ /usr/bin/g++-11 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-11 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 \
    --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11  --slave /usr/bin/cpp cpp /usr/bin/cpp-11
RUN cd /source && mkdir build && cd build
# conan profile new default --detect && \
# conan profile update settings.compiler.libcxx=libstdc++11 default && \
# conan install ..  --build missing --settings build_type=Debug

RUN apt-get install -y curl
RUN apt-get install -y vim-tiny

COPY install_boost.sh /tmp/install_boost.sh
RUN ./tmp/install_boost.sh 1.77.0
ENV BOOST_ROOT=/opt/boost
COPY install_openssl.sh /tmp/install_openssl.sh
RUN ./tmp/install_openssl.sh
RUN cd /source/build && \
    conan profile new default --detect && \
    conan profile update settings.compiler.libcxx=libstdc++11 default && \
    conan install ..  --build missing --settings build_type=Debug
ENV OPENSSL_ROOT=/opt/local/openssl
RUN apt-get install -y pkg-config zlib1g
RUN cd /source/build && cmake .. -DCMAKE_TOOLCHAIN_FILE:FILEPATH=build/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug -Dunity=Off
RUN cd /source/build && cmake --build . --parallel $(nproc)
# COPY example-config.json /source/example-config.json
RUN strip /source/build/xbridge_witnessd

FROM ubuntu:22.04
RUN mkdir /opt/xbridge-witness
COPY --from=0 /source/build/xbridge_witnessd /opt/xbridge-witness/xbridge_witnessd
# COPY --from=0 /source/example-config.json /opt/xbridge-witness/cfg/example-config.json

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
