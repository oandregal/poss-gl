#!/bin/bash

msgfmt --statistics -o /dev/null $1 2>/tmp/foo

echo "$1:"`cat /tmp/foo`
