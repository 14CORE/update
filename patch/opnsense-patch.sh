#!/bin/sh

# Copyright (c) 2016 Franco Fichtner <franco@opnsense.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

set -e

# internal vars
WORKDIR="/tmp/opnsense-patch"
PREFIX="/usr/local"

# fetch defaults
SITE="https://github.com/"
ACCOUNT="opnsense"
REPOSITORY="core"
PATCHLEVEL="2"

if [ "$(id -u)" != "0" ]; then
	echo "Must be root."
	exit 1
fi

mkdir -p ${WORKDIR}

for ARG in ${@}; do
	fetch -q "${SITE}/${ACCOUNT}/${REPOSITORY}/commit/${ARG}.patch" \
	    -o "${WORKDIR}/${ARG}.patch"
done

for ARG in ${@}; do
	patch -Et -p ${PATCHLEVEL} -d "${PREFIX}" -i "${WORKDIR}/${ARG}.patch"
done

rm -rf ${WORKDIR}/*

echo "All patches have been applied successfully.  Have a nice day."
