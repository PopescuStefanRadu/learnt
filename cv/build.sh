#!/bin/bash

NAME=$1
PHONE=$2
MAIL=$3

if [ -z "$NAME" ] || [ -z $PHONE ] || [ -z $MAIL ]
then
  echo "One or more parameters are missing. Parameter order: name phone mail"
  echo 'Example usage: ./build.sh "John Doe" "+40721212121" "mail@example.com"'
  exit 1
fi

sed < cv.tex "s/PURUPURUNAME/$NAME/;s/PURUPURUPHONE/$PHONE/;s/PURUPURUMAIL/$MAIL/g" | pdflatex
