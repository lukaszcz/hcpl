#!/bin/bash

ocamlwc `find src -name '*.ml' -print -o -name '*.mli' -print -o -name '*.mll' -print | sort`
