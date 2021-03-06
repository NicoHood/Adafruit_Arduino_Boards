#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Author: Todd Treece <todd@uniontownlabs.org>
# Copyright (c) 2015 Adafruit Industries
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

PACKAGE_VERSION="1.3.0"

# boards are served via github pages
BOARD_DOWNLOAD_URL="https:\/\/adafruit.github.io\/arduino-board-index\/boards"

# get package script directory
REPO_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

read -r -d '' TEEJSON <<'EOF'
{
   "name":"Adafruit TeeOnArdu",
   "architecture":"avr",
   "version":"PACKAGEVERSION",
   "category":"Adafruit",
   "url":"DOWNLOADURL/adafruit-teeonardu-PACKAGEVERSION.tar.bz2",
   "archiveFileName":"adafruit-teeonardu-PACKAGEVERSION.tar.bz2",
   "checksum":"SHA-256:PACKAGESHA",
   "size":"PACKAGESIZE",
   "help":{
      "online":"https://forums.adafruit.com"
   },
   "boards":[
      {
        "name":"TeeOnArdu (Leo on TeensyCore)"
      },
      {
        "name":"Flora (TeensyCore)"
      }
   ],
   "toolsDependencies": []
}
EOF

read -r -d '' SAMDJSON <<'EOF'
{
   "name":"Adafruit SAMD Boards",
   "architecture":"samd",
   "version":"PACKAGEVERSION",
   "category":"Adafruit",
   "url":"DOWNLOADURL/adafruit-samd-PACKAGEVERSION.tar.bz2",
   "archiveFileName":"adafruit-samd-PACKAGEVERSION.tar.bz2",
   "checksum":"SHA-256:PACKAGESHA",
   "size":"PACKAGESIZE",
   "help":{
      "online":"https://forums.adafruit.com"
   },
   "boards":[
      {
         "name":"Adafruit Feather M0"
      }
   ],
   "toolsDependencies": [
     {
       "packager": "arduino",
       "name": "arm-none-eabi-gcc",
       "version": "4.8.3-2014q1"
     },
     {
       "packager": "arduino",
       "name": "bossac",
       "version": "1.6.1-arduino"
     },
     {
       "packager": "arduino",
       "name": "openocd",
       "version": "0.9.0-arduino"
     },
     {
       "packager": "arduino",
       "name": "CMSIS",
       "version": "4.0.0-atmel"
     }
   ]
}
EOF

read -r -d '' SAMDJSON <<'EOF'
{
   "name":"Adafruit SAMD Boards",
   "architecture":"samd",
   "version":"PACKAGEVERSION",
   "category":"Adafruit",
   "url":"DOWNLOADURL/adafruit-samd-PACKAGEVERSION.tar.bz2",
   "archiveFileName":"adafruit-samd-PACKAGEVERSION.tar.bz2",
   "checksum":"SHA-256:PACKAGESHA",
   "size":"PACKAGESIZE",
   "help":{
      "online":"https://forums.adafruit.com"
   },
   "boards":[
      {
         "name":"Adafruit Feather M0"
      }
   ],
   "toolsDependencies": [
     {
       "packager": "arduino",
       "name": "arm-none-eabi-gcc",
       "version": "4.8.3-2014q1"
     },
     {
       "packager": "arduino",
       "name": "bossac",
       "version": "1.6.1-arduino"
     },
     {
       "packager": "arduino",
       "name": "openocd",
       "version": "0.9.0-arduino"
     },
     {
       "packager": "arduino",
       "name": "CMSIS",
       "version": "4.0.0-atmel"
     }
   ]
}
EOF

read -r -d '' AVRJSON <<'EOF'
{
   "name":"Adafruit AVR Boards",
   "architecture":"avr",
   "version":"PACKAGEVERSION",
   "category":"Adafruit",
   "url":"DOWNLOADURL/adafruit-avr-PACKAGEVERSION.tar.bz2",
   "archiveFileName":"adafruit-avr-PACKAGEVERSION.tar.bz2",
   "checksum":"SHA-256:PACKAGESHA",
   "size":"PACKAGESIZE",
   "help":{
      "online":"https://forums.adafruit.com"
   },
   "boards":[
      {
         "name":"Adafruit Flora"
      },
      {
         "name":"Adafruit Gemma 8MHz"
      },
      {
         "name":"Adafruit Bluefruit Micro"
      },
      {
         "name":"Adafruit Feather 32u4"
      },
      {
         "name":"Adafruit Metro"
      },
      {
         "name":"Adafruit Pro Trinket 5V/16MHz (USB)"
      },
      {
         "name":"Adafruit Pro Trinket 3V/12MHz (USB)"
      },
      {
         "name":"Adafruit Pro Trinket 5V/16MHz (FTDI)"
      },
      {
         "name":"Adafruit Pro Trinket 3V/12MHz (FTDI)"
      },
      {
         "name":"Adafruit Trinket 8MHz"
      },
      {
         "name":"Adafruit Trinket 16MHz"
      }
   ],
   "toolsDependencies":[]
}
EOF

# clean build dir
cd $REPO_DIR
rm -r build
mkdir build

function archive() {

  # args: archive_name source_path sha_return size_return

  local  __sha=$3
  local  __size=$4

  echo "building $1.tar.bz2..."
  cd $REPO_DIR
  cp -a $2 build/$1
  cd build
  tar -jcf $1.tar.bz2 $1
  rm -r $1

  local sha=$(openssl dgst -sha256 $1.tar.bz2 | awk '{print $2}')
  local size=$(ls -l | grep $1 | awk '{print $5}')

  eval $__sha="'$sha'"
  eval $__size="'$size'"

}

read -p "AVR VERSION: " input
PACKAGE_VERSION=$input

cd $REPO_DIR

#update platform version
sed -i .bak -e "s/^version=.*/version=$PACKAGE_VERSION/" hardware/adafruit/avr/platform.txt

# create archives and get sha & size
archive "adafruit-avr-$PACKAGE_VERSION" hardware/adafruit/avr PACKAGESHA PACKAGESIZE

cd $REPO_DIR

# fill in board json templatee
echo $AVRJSON | sed -e "s/PACKAGEVERSION/$PACKAGE_VERSION/g" \
                 -e "s/DOWNLOADURL/$BOARD_DOWNLOAD_URL/g" \
                 -e "s/PACKAGESHA/$PACKAGESHA/g" \
                 -e "s/PACKAGESIZE/$PACKAGESIZE/g" > build/avr_package.json

read -p "SAMD VERSION: " input
PACKAGE_VERSION=$input

cd $REPO_DIR

#update platform version
sed -i .bak -e "s/^version=.*/version=$PACKAGE_VERSION/" hardware/adafruit/samd/platform.txt
sed -i .bak -e "s/^name=.*/name=Adafruit SAMD Boards/" hardware/adafruit/samd/platform.txt

# create archives and get sha & size
archive "adafruit-samd-$PACKAGE_VERSION" hardware/adafruit/samd PACKAGESHA PACKAGESIZE

cd $REPO_DIR

# fill in board json templatee
echo $SAMDJSON | sed -e "s/PACKAGEVERSION/$PACKAGE_VERSION/g" \
                 -e "s/DOWNLOADURL/$BOARD_DOWNLOAD_URL/g" \
                 -e "s/PACKAGESHA/$PACKAGESHA/g" \
                 -e "s/PACKAGESIZE/$PACKAGESIZE/g" > build/samd_package.json

read -p "TeeOnArdu VERSION: " input
PACKAGE_VERSION=$input

cd $REPO_DIR

#update platform version
sed -i .bak -e "s/^version=.*/version=$PACKAGE_VERSION/" hardware/teeonardu/avr/platform.txt

# create archives and get sha & size
archive "adafruit-teeonardu-$PACKAGE_VERSION" hardware/teeonardu/avr PACKAGESHA PACKAGESIZE

cd $REPO_DIR

# fill in board json templatee
echo $TEEJSON | sed -e "s/PACKAGEVERSION/$PACKAGE_VERSION/g" \
                 -e "s/DOWNLOADURL/$BOARD_DOWNLOAD_URL/g" \
                 -e "s/PACKAGESHA/$PACKAGESHA/g" \
                 -e "s/PACKAGESIZE/$PACKAGESIZE/g" > build/tee_package.json
