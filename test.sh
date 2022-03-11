#!/bin/bash


cat test.txt | sed -n 's|.*"changes_count":\([^,]*\).*|\1|p' | sed 's/[^0-9]*//g'
