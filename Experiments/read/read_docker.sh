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
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=libaio --directory=/mnt --bs=4k --iodepth=4 --readwrite=randread --direct=1 --invalidate=0 --numjobs=1 --group_reporting --name=job$weight --size=1500m  &
	done
	
	wait

	fio --ioengine=libaio --directory=/mnt --bs=4k --iodepth=4 --readwrite=randread --direct=1 --invalidate=0 --numjobs=1 --group_reporting --name=tmp --size=1G > ./tmp

	echo "========================================================="

	echo 1 > /sys/fs/bcache/*/clear_stats

	for weight in 100 200 400 800
	do	
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=libaio --directory=/mnt --bs=4k --iodepth=4 --readwrite=randread --direct=1 --invalidate=0 --numjobs=1 --group_reporting --time_based --runtime=60 --name=job$weight --size=1500m &
	done

	wait
	
	for weight in 100 200 400 800
do	
	docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=libaio --directory=/mnt --bs=4k --iodepth=4 --readwrite=randread --direct=1 --invalidate=0 --numjobs=1 --group_reporting --time_based --runtime=60 --name=job$weight --size=1500m &
done

	echo "cache hit ratio"

	cat /sys/fs/bcache/*/stats_total/cache_hit_ratio

#	(cd ../../bcache && ./drop.sh)
done


