#!/bin/bash
for p in 1
do
	#init
	systemctl stop docker
	#	umount /mnt
	#	mkfs.ext4 /dev/sdb1
	#	mount -t ext4 /dev/sdb1 /mnt
	#	fstrim /mnt -v

	systemctl start docker

	docker pull keinoh/journal:1.5

	#cache flush
	free -m
	sync
	echo 3 > /proc/sys/vm/drop_caches
	free -m


	#execute 4 container with fio running

	for weight in 100 200 400 800
	do	

		mkdir /mnt/$weight
		docker run --blkio-weight=${weight} -v /mnt/$weight:/mnt --name test$weight keinoh/journal:1.5 &
	done
done


