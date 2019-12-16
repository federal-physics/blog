#!/bin/env sh

set -e

lstrip() {
    # Usage: lstrip "string" "pattern"
    printf '%s\n' "${1##$2}"
}

echo '% Brain Dump' >index.md

# shellcheck disable=SC2010
pages="$(ls -1t | grep .md | grep -vE "README|index")"

for page in $pages; do
    case $page in
    README.md) ;;
    index.md) ;;
    *)
        filename="${page%.*}"
        pandoc -s --css styles.css -f markdown -t html -o "$filename".html "$page"
        page_title="$(head -n 1 "$page")"
        page_title="$(lstrip "$page_title" '% ')"
        echo "* [$page_title]($filename.html)" >>index.md
        echo "Converted $page"
        ;;
    esac

done

pandoc -s --css styles.css -f markdown -t html -o index.html index.md
echo "Converted index.md"

echo "Done!"
