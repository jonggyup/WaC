#!/bin/bash
yes | mkfs.ext4 /dev/bcache0
mount /dev/bcache0 /mnt
