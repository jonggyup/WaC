#!/bin/bash
backing1=/dev/sdb1
cache=/dev/nvme1n1p1

make-bcache -B $backing1 -C $cache --wipe-bcache

echo /dev/nvme1n1p1 > /sys/fs/bcache/register

echo /dev/nvme1n1p1 > /sys/block/bcache0/bcache/attach

sleep 3
echo writeback > /sys/block/bcache0/bcache/cache_mode
