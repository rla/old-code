#!/bin/sh

echo "\\begin{verbatim}"
sed 's/\t/        /' $1 | iconv -f utf-8 -t iso-8859-15
echo "\\end{verbatim}"