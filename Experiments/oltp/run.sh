#!/bin/bash
for p in 1
do
	echo 0 > /proc/sys/kernel/randomize_va_space
	(cd ../../bcache && ./start.sh)
	#init
	systemctl stop docker
	systemctl start docker

	#cache flush
	free -m
	sync
	echo 3 > /proc/sys/vm/drop_caches
	free -m
	
	#execute 4 container with ycsb benchmarks
	for weight in 100 200 400 800
	do	
		mkdir /mnt/$weight
		docker run -i --rm --blkio-weight=${weight} -v /mnt/$weight:/mnt --entrypoint="filebench" jonggyu -f /home/jonggyu/filebench/workloads/oltp.f &
	done
	
	#echo 1 > /sys/fs/bcache/*/clear_stats

	wait

	echo "cache hit ratio"

	cat /sys/fs/bcache/*/stats_total/cache_hit_ratio

#	(cd ../../bcache && ./drop.sh)
done


