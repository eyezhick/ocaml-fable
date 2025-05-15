#!/bin/bash

# Create _build directory if it doesn't exist
mkdir -p _build

# Copy web files to root
cp web/index.html _build/
cp _build/default/web/fable_web.bc.js _build/
cp _build/default/web/fable_web.bc.js.map _build/ 2>/dev/null || true

# Create .nojekyll to prevent GitHub Pages from processing the site
touch _build/.nojekyll 