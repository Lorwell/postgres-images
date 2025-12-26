# pg 版本
ARG PG_MAJOR=18
ARG DEBIAN_CODENAME=bookworm
FROM postgres:$PG_MAJOR-$DEBIAN_CODENAME AS base

# zhparser
FROM base AS zhparser
ARG PG_MAJOR

ARG DEBIAN_FRONTEND=noninteractive
RUN set -ex \
  && apt-get update \
  && apt-get install -y build-essential git postgresql-server-dev-${PG_MAJOR} pkg-config binutils automake libtool \
  && apt-get clean

RUN set -ex \
  && git clone --branch 1.2.3 --single-branch --depth 1 https://github.com/hightman/scws.git \
  && cd scws \
  && touch README;aclocal;autoconf;autoheader;libtoolize;automake --add-missing \
  && ./configure \
  && make install

RUN set -ex \
  && git clone --branch master --single-branch --depth 1 https://github.com/amutu/zhparser.git \
  && cd zhparser \
  && make install

# pgvertor
FROM base AS pgvertor
ARG PG_MAJOR

ADD https://github.com/pgvector/pgvector.git#v0.8.1 /tmp/pgvector

RUN apt-get update && \
		apt-mark hold locales && \
		apt-get install -y --no-install-recommends build-essential postgresql-server-dev-$PG_MAJOR && \
		cd /tmp/pgvector && \
		make clean && \
		make OPTFLAGS="" && \
		make install && \
		mkdir /usr/share/doc/pgvector && \
		cp LICENSE README.md /usr/share/doc/pgvector && \
		rm -r /tmp/pgvector && \
		apt-get remove -y build-essential postgresql-server-dev-$PG_MAJOR && \
		apt-get autoremove -y && \
		apt-mark unhold locales && \
		rm -rf /var/lib/apt/lists/*

# Apache AGE (图数据库扩展)
FROM base AS apache_age
ARG PG_MAJOR=18
ARG AGE_VERSION=PG${PG_MAJOR}

RUN apt-get update && \
		apt-mark hold locales && \
		apt-get install -y --no-install-recommends build-essential git cmake postgresql-server-dev-$PG_MAJOR libreadline-dev && \
		git clone --branch ${AGE_VERSION} --single-branch --depth 1 https://github.com/apache/age.git /tmp/age && \
		cd /tmp/age && \
		mkdir build && cd build && \
		cmake .. && \
		make install && \
		mkdir -p /usr/share/doc/apache-age && \
		cp LICENSE README.md /usr/share/doc/apache-age && \
		rm -rf /tmp/age && \
		apt-get remove -y build-essential git cmake postgresql-server-dev-$PG_MAJOR libreadline-dev && \
		apt-get autoremove -y && \
		apt-mark unhold locales && \
		rm -rf /var/lib/apt/lists/*

# 最终镜像，合并所有扩展
FROM base
ARG PG_MAJOR

# 安装中文环境
RUN localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

# 复制 zhparser 结果
COPY --from=zhparser /usr/lib/postgresql/${PG_MAJOR}/lib/zhparser.so /usr/lib/postgresql/${PG_MAJOR}/lib/
COPY --from=zhparser /usr/local/lib/libscws.* /usr/local/lib/
COPY --from=zhparser /usr/share/postgresql/${PG_MAJOR}/extension/zhparser* /usr/share/postgresql/${PG_MAJOR}/extension/
COPY --from=zhparser /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/zhparser* /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/
COPY --from=zhparser /usr/share/postgresql/${PG_MAJOR}/tsearch_data/*.utf8.* /usr/share/postgresql/${PG_MAJOR}/tsearch_data/

# 复制 pgvector 扩展文件
COPY --from=pgvertor /usr/lib/postgresql/${PG_MAJOR}/lib/vector.so /usr/lib/postgresql/${PG_MAJOR}/lib/
COPY --from=pgvertor /usr/share/postgresql/${PG_MAJOR}/extension/vector* /usr/share/postgresql/${PG_MAJOR}/extension/

# 复制 Apache AGE 扩展文件
COPY --from=apache_age /usr/lib/postgresql/${PG_MAJOR}/lib/age.so /usr/lib/postgresql/${PG_MAJOR}/lib/
COPY --from=apache_age /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/age* /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/
COPY --from=apache_age /usr/share/postgresql/${PG_MAJOR}/extension/age* /usr/share/postgresql/${PG_MAJOR}/extension/