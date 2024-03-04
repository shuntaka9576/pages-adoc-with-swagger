#!/bin/bash

BIN_PATH="$(dirname -- ${0})"
DIST_PATH="dist"
DOCUMENT_DIR="documents"
ASSET_DIR="$DOCUMENT_DIR/assets"
DOC_DIR="$DOCUMENT_DIR/docs"

rm -rf $DIST_PATH

# AsciiDocの再起的ビルド
for filename in $(find $DOC_DIR -type f |cut -d/ -f3- | grep .adoc); do
  asciidoctor \
    -a imagesdir@=images \
    -a imagesoutdir=$DIST_PATH/images \
    -a outdir=$DIST_PATH \
    -o $DIST_PATH/${filename%.*}.html \
    -r asciidoctor-diagram \
    -b html5 \
    $DOC_DIR/${filename}
done

# swaggerの設定
cp "$DOC_DIR/blog-api/api.yml" $DIST_PATH/blog-api/
perl -pe 's/<ymlPath>/api.yml/g' "$ASSET_DIR/swagger-ui.html" > $DIST_PATH/blog-api/api.html
