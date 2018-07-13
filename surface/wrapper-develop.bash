#!/bin/bash

cd /root/surface
pip install --no-cache-dir -r etc/requirements.txt && pip install -e .
~/docker_config.bash
