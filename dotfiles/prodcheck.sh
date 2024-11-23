#!/bin/bash

cat ~/.kube/config | rg current-context | rg production > /dev/null && echo "prod->"
