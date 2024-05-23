# nativejson-benchmark
# build with: docker build -t nativejson-benchmark .
FROM debian:bookworm

COPY . /nativejson-benchmark
WORKDIR /nativejson-benchmark
ENV PATH $PATH:/nativejson-benchmark/build

RUN buildDeps='build-essential gcc-multilib g++-multilib git-core curl ca-certificates php8.2-cli libboost-all-dev'; \
	set -x \
	&& sed -i -e "s%http://deb.debian.org%http://mirrors.ustc.edu.cn%g" -e "s%http://security.debian.org%http://mirrors.ustc.edu.cn%g" /etc/apt/sources.list.d/debian.sources \
	&& apt-get update && apt-get install --no-install-recommends -y $buildDeps \
	&& cd /nativejson-benchmark \
	&& if [ -n ${GIT_PROXY} ]; then git config --global url."${GIT_PROXY}/".insteadOf https://; fi \\
	&& git submodule update --init \
	&& git -C thirdparty/boost submodule update --init \
	&& cd build \
	&& curl -L -s https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz | tar -xvz \
	&& chmod +x premake5 && chmod +x premake.sh && sync && /bin/sh -c ./premake.sh && ./machine.sh \
	&& cd /nativejson-benchmark && make \
	&& cd /nativejson-benchmark/bin \
	&& for t in *; do ./$t; done \
	&& cd /nativejson-benchmark/result && make \
	&& apt-get purge -y --auto-remove $buildDeps

VOLUME ["/nativejson-benchmark/output"]
