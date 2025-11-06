#!/bin/sh

# Install the Monokai Light color scheme into BBEdit's Color Schemes directory.

set -eu

SCHEME_NAME="Monokai Light.bbColorScheme"
SCHEME_SOURCE="color-schemes/${SCHEME_NAME}"
REPO_URL="https://github.com/binbinsh/bbedit-monokai-light.git"

if ! command -v git >/dev/null 2>&1; then
  printf '%s\n' "git is required to download ${SCHEME_NAME}." >&2
  exit 1
fi

color_schemes_dir="${HOME}/Library/Application Support/BBEdit/Color Schemes"
mkdir -p "${color_schemes_dir}"

tmp_dir=$(mktemp -d)
cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT INT HUP TERM

git clone --depth 1 "${REPO_URL}" "${tmp_dir}/repo" >/dev/null 2>&1

scheme_path="${tmp_dir}/repo/${SCHEME_SOURCE}"
if [ ! -f "${scheme_path}" ]; then
  printf '%s\n' "Failed to locate ${SCHEME_SOURCE} in cloned repository." >&2
  exit 1
fi

target_path="${color_schemes_dir}/${SCHEME_NAME}"

cp "${scheme_path}" "${target_path}"
printf '%s\n' "Installed ${SCHEME_NAME} into ${color_schemes_dir}."
