set -ex

TOOLCHAIN_NAME="$(cat .swift-version)"
TOOLCHAIN_DOWNLOAD="https://github.com/swiftwasm/swift/releases/download/swift-$TOOLCHAIN_NAME/swift-$TOOLCHAIN_NAME-linux.tar.gz"

git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
export SWIFTENV_ROOT="$HOME/.swiftenv"
export PATH="$SWIFTENV_ROOT/bin:$PATH"
eval "$(swiftenv init -)"
swiftenv install $TOOLCHAIN_DOWNLOAD

apt-get install gcc-4.9
apt-get upgrade libstdc++6

npm install
npm run build:prod
