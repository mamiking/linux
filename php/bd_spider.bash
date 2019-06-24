#!/bin/bash
cat $(ll -rt|awk '{print $9}')> ../all.txt