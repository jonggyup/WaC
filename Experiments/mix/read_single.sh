#!/bin/bash



for p in 1 2 3 4
do
	#init
	#execute 4 container with fio running
	for weight in 100 200 400 800
	do	
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=sync --directory=/mnt --bs=128k --iodepth=4 --readwrite=randrw --direct=1 --invalidate=0 --numjobs=16 --group_reporting --name=job$weight --size=500m &
	done

	wait
done
	
	echo "TIME BASED START"

	for weight in 100 200 400 800
	do	
		docker run -i --rm --blkio-weight=${weight} -v /mnt:/mnt --entrypoint="fio" keinoh/journal:1.5 --ioengine=sync --directory=/mnt --bs=128k --iodepth=4 --readwrite=randrw --direct=1 --invalidate=0 --numjobs=16 --group_reporting --name=job$weight --size=500m --time_based --runtime=200 &
	done


