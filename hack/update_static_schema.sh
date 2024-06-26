#!/usr/bin/env bash

set -euox pipefail

# Get the k8s library version from go.mod, stripping the trailing newline
k8s_lib_version=$(grep "k8s.io/client-go" go.mod | awk '{print $2}' | head -n 1 | tr -d '\n')

# Download the parser file from the k8s library
curl -sL "https://raw.githubusercontent.com/kubernetes/client-go/$k8s_lib_version/applyconfigurations/internal/internal.go" -o pkg/utils/kube/scheme/parser.go

# Add a line to the beginning of the file saying that this is the script that generated it.
sed -i '' '1s/^/\/\/ Code generated by hack\/update_static_schema.sh; DO NOT EDIT.\n\/\/ Everything below is downloaded from applyconfigurations\/internal\/internal.go in kubernetes\/client-go.\n\n/' pkg/utils/kube/scheme/parser.go

# Replace "package internal" with "package scheme" in the parser file
sed -i '' 's/package internal/package scheme/' pkg/utils/kube/scheme/parser.go

# Replace "func Parser" with "func StaticParser"
sed -i '' 's/func Parser/func StaticParser/' pkg/utils/kube/scheme/parser.go
