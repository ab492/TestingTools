#!/usr/bin/env zsh

# Modified from a script by Jon Reid, https://qualitycoding.org (https://github.com/jonreid/TCR-Xcode)

statusResult=$(git status -u --porcelain)
if [[ -z $statusResult ]]; then
  exit 0
fi

git add .

git commit