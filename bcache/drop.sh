#!/bin/bash
backing1=/dev/sdb1
cache=/dev/nvme1n1p1


#if the device busy, need to detach first
#echo 1 > /sys/block/dev/devpartition/bcache/detach or stop
umount /dev/sdb1
umount /dev/bcache0

echo /dev/nvme1n1p1 > /sys/block/bcache0/bcache/detach

echo 1 > /sys/block/sdb/sdb1/bcache/detach

echo 1 > /sys/block/sdb/sdb1/bcache/stop

echo 1 > /sys/fs/bcache/*/stop
echo 1 > /sys/fs/bcache/*/unregister




wipefs -af $backing1
wipefs -af $cache

