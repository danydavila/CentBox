#!/usr/bin/env bash
# Clear The Old Variables

sed -i '/# Set Environment Variable/,+1d' /home/vagrant/.bash_profile
