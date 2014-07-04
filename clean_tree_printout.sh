#!/bin/bash

awk -F'\t' '{printf "%12s %14s %15s %7s\n", $1, $2, $3, $18}' $1
