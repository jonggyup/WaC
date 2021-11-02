#!/bin/bash



for p in 1 2 3 4 5
do

	echo 1 > /sys/fs/bcache/*/clear_stats
	for weight in 100 200 400 800
	do	
		echo "Experiment" $p "starts"
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=sync --directory=/mnt --bs=128k --iodepth=4 --readwrite=randrw --direct=1 --invalidate=0 --numjobs=16 --group_reporting --name=job$weight --size=400m &
	done

	wait

	echo "cache hit ratio = "
	cat /sys/fs/bcache/*/stats_total/cache_hit_ratio
	echo " "

done
	
	echo "TIME BASED START"

	echo 1 > /sys/fs/bcache/*/clear_stats
	for weight in 100 200 400 800
	do	
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=sync --directory=/mnt --bs=128k --iodepth=4 --readwrite=randrw --direct=1 --invalidate=0 --numjobs=16 --group_reporting --name=job$weight --size=400m --time_based --runtime=120 &
	done

	wait

	echo "cache hit ratio = "
	cat /sys/fs/bcache/*/stats_total/cache_hit_ratio
	echo " "




