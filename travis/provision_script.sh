#!/usr/bin/env bash

cd $TRAVIS_BUILD_DIR/orchestration
terraform init
terraform apply
