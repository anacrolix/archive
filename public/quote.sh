#!/bin/bash
set -ex
python -c 'import sys; print sys.argv' $*
python -c 'import sys; print sys.argv' "$*"
python -c 'import sys; print sys.argv' $@
python -c 'import sys; print sys.argv' "$@"
