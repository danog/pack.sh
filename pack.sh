#!/bin/bash
# pack.sh
# Created by Daniil Gentili (http://daniil.it)
# Pack/unpack numbers to/from binary (base 256) format.
#
# Copyright 2016 Daniil Gentili (https://daniil.it)
# This file is part of video-dl.
# video-dl is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# video-dl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU General Public License along with the video-dl.
# If not, see <http://www.gnu.org/licenses/>.

ord() {
	LC_CTYPE=C printf '%d' "'$1"
}
chr() {
 	[ "$1" -gt 255 ] && return 1
 	[ "$1" -eq 0 ] && printf "%b" '\0' || printf "\\$(printf '%03o' "$1")"
}
unpack_number() {
	[ -z "$1" ] && echo "No data provided!">&2 && return 1
	local number=0
	local max=$((2 ** (${#1}*8-1) + -1))
	local min=$((2 ** (${#1}*8-1) * -1))
	for i in $(seq 1 ${#1}); do
		number=$(($number | ($(ord "${1:i-1:1}") << 8*($i-1))))
	done
	echo -n $number
}

pack_number() {
	[ -z "$2" ] && echo "No data provided!">&2 && return 1
	local binary=""
	local max=$((2 ** (${1}*8-1) + -1))
	local min=$((2 ** (${1}*8-1) * -1))
	[ "$2" -lt "$min" ] && echo "Number is lower than the current limit $min" 2>&1 && return 1
	[ "$2" -gt "$max" ] && echo "Number is greater than the current limit $max" 2>&1 && return 1
	for i in $(seq 1 ${1}); do
		chr $((($2 >> 8*($i-1)) & 255))
	done
}
