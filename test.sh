#!/bin/bash
if [[ "$@" =~ "origin \.\+" ]]; then
  echo "origin"
else
  echo "no origin"
fi
