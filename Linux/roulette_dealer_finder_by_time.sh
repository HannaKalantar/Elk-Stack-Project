#!/bin/sh

date=$1
timestamp=$2

grep "${timestamp}" "${date}_Dealer_schedule" | awk '{ print $1,$2,$5,$6 }'
