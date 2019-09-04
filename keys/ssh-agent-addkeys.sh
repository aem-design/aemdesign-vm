#!/usr/bin/env bash

NOPASS=true
PASS="$(pwd)/current/cert.password"

eval "$(ssh-agent)"

for file in current/*
do

extension="${file##*.}"
filename="${file%.*}"


if [[ "$filename" != "current/authorized_keys" && "$extension" != "pub" && "$extension" != "password" ]]; then

echo "filename: $filename"
if [ "$NOPASS" != "true" ]; then

expect << EOF
  spawn ssh-add filename
  expect "Enter passphrase"
  send "$(cat "$PASS")\r"
  expect eof
EOF

else

ssh-add "$filename"

fi

fi


done
