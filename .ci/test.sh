#!/bin/bash
set -ex

SOURCE_PATH="$(cd "$(dirname $0)/.." && pwd)"
cd $SOURCE_PATH

source $SOURCE_PATH/.ci/install-swift.sh

swift test
