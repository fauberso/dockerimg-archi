#!/bin/#!/usr/bin/env bash
docker login
docker build . -t `whoami`/archi
docker push `whoami`/archi
