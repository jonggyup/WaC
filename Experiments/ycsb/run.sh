#!/bin/bash
for p in 1
do
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
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="./bin/ycsb load rocksdb" jonggyu -s -P workloads/workloda -p rocksdb.dir=/mnt/ycsb-rocksdb-data jonggyu &
	done
	
	#echo 1 > /sys/fs/bcache/*/clear_stats

	wait

	echo "cache hit ratio"

	cat /sys/fs/bcache/*/stats_total/cache_hit_ratio

#	(cd ../../bcache && ./drop.sh)
done


