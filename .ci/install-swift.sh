case $(uname -s) in
  Darwin)
    OS_SUFFIX=osx
  ;;
  Linux)
    OS_SUFFIX=linux
  ;;
  *)
    echo "Unrecognised platform $(uname -s)"
    exit 1
  ;;
esac


TOOLCHAIN_NAME="$(cat .swift-version)"
TOOLCHAIN_DOWNLOAD="https://github.com/swiftwasm/swift/releases/download/swift-$TOOLCHAIN_NAME/swift-$TOOLCHAIN_NAME-$OS_SUFFIX.tar.gz"

git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
export SWIFTENV_ROOT="$HOME/.swiftenv"
export PATH="$SWIFTENV_ROOT/bin:$PATH"
eval "$(swiftenv init -)"
swiftenv install $TOOLCHAIN_DOWNLOAD
