#!/usr/bin/env bash
set -e

APACHE_VERSION="2.4.65"
APR_VERSION="1.7.6"
APR_UTIL_VERSION="1.6.3"

WORKDIR=/tmp/httpd-build
PREFIX=/usr/local/apache2

BASE_HTTPD_URL="https://dlcdn.apache.org/httpd"
BASE_APR_URL="https://dlcdn.apache.org/apr"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "Downloading sources..."
curl -fSL "${BASE_HTTPD_URL}/httpd-${APACHE_VERSION}.tar.gz" -o "httpd-${APACHE_VERSION}.tar.gz"
curl -fSL "${BASE_APR_URL}/apr-${APR_VERSION}.tar.gz" -o "apr-${APR_VERSION}.tar.gz"
curl -fSL "${BASE_APR_URL}/apr-util-${APR_UTIL_VERSION}.tar.gz" -o "apr-util-${APR_UTIL_VERSION}.tar.gz"

check_tar() {
  local file="$1"
  if ! tar -tf "$file" >/dev/null 2>&1; then
    echo "File '$file' is not a valid tar archive. Check URL/version for $file"
    exit 1
  fi
}

check_tar "httpd-${APACHE_VERSION}.tar.gz"
check_tar "apr-${APR_VERSION}.tar.gz"
check_tar "apr-util-${APR_UTIL_VERSION}.tar.gz"

echo "Extracting..."
tar -xf "httpd-${APACHE_VERSION}.tar.gz"
tar -xf "apr-${APR_VERSION}.tar.gz"
tar -xf "apr-util-${APR_UTIL_VERSION}.tar.gz"

mv "apr-${APR_VERSION}"       "httpd-${APACHE_VERSION}/srclib/apr"
mv "apr-util-${APR_UTIL_VERSION}" "httpd-${APACHE_VERSION}/srclib/apr-util"

cd "httpd-${APACHE_VERSION}"

echo "Configuring..."
./configure \
  --prefix="$PREFIX" \
  --enable-so \
  --enable-ssl \
  --enable-cgi \
  --enable-rewrite \
  --with-mpm=event \
  --with-included-apr \
  --enable-mods-shared=all

echo "Building..."
make -j"$(getconf _NPROCESSORS_ONLN)"
echo "Installing..."
make install

echo "<h1>Apache</h1>" > "$PREFIX/htdocs/index.html"

echo "Cleaning up..."
rm -rf "$WORKDIR"

echo "Apache installed to $PREFIX"
