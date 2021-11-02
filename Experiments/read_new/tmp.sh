#!/bin/bash

#execute 4 container with ycsb benchmarks
for weight in 100 200 400 800
do	
	mkdir /mnt/group$weight
	cp ./read.fio /mnt/group$weight/

	sudo docker run \
	--blkio-weight=${weight} \
	--name test$weight \
	-v /mnt/group$weight:/mnt \
	jonggyupark/mysql:latest &

done

#echo 1 > /sys/fs/bcache/*/clear_stats

wait

echo "cache hit ratio"

cat /sys/fs/bcache/*/stats_total/cache_hit_ratio


