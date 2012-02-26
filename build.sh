#! /bin/bash
#
# Copyright © 2009, 2012 Siegfried-A. Gevatter Pujals <siegfried@gevatter.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

PROJECT_NAME="index"

CURDIR="$(pwd)"
TMPDIR=`mktemp -d /tmp/latex-build-XXXXXXX`
OPTIONS=""
OPEN=0

while [ $# -gt 0 ]
do
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "Usage: $0 [options]"
        echo
        echo "Options:"
        echo -e "\t-h, --help\tShow this help"
        echo -e "\t-q, -quiet\tPrint less output"
        echo -e "\t-o, --open\tOpen the result in the default PDF viewer"
        exit 0
    fi

    if [ "$1" = "-q" ] || [ "$1" = "--quiet" ]
    then
        OPTIONS=$OPTIONS" -interaction batchmode"
        shift 1
        continue
    fi

    if [ "$1" = "-o" ] || [ "$1" = "--open" ]
    then
        OPEN=1
        shift 1
        continue
    fi

    echo "Unrecognized argument: $1"
    exit 1
done

mkdir -p "$TMPDIR"
cp -r * "$TMPDIR"
cd $TMPDIR

pdflatex $OPTIONS "$PROJECT_NAME" &&
pdflatex $OPTIONS "$PROJECT_NAME" &&
bibtex "$PROJECT_NAME" | grep -v 'Warning--to sort, need author' &&
pdflatex $OPTIONS "$PROJECT_NAME" &&
pdflatex $OPTIONS "$PROJECT_NAME" &&
cp "$PROJECT_NAME".pdf "$CURDIR"

cd "$CURDIR"

rm -rf "$TMPDIR"

if [ $OPEN = 1 ]
then
    xdg-open "$PROJECT_NAME".pdf
fi
