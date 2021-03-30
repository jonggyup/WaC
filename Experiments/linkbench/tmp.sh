#!/bin/bash

#(cd ../../../bcache && ./start.sh)
#init
#systemctl stop docker
#systemctl start docker

#cache flush
#free -m
#sync
#echo 3 > /proc/sys/vm/drop_caches
#free -m

#execute 4 container with ycsb benchmarks
for weight in 100 200 400 800
do	
	mkdir /mnt/group$weight
	mkdir /mnt/group$weight/datadir
	mkdir /mnt/group$weight/logdir
	mkdir /mnt/group$weight/conf
	cp ./my.cnf /mnt/group$weight/conf/

	sudo chown -R 999:docker /mnt/group$weight/datadir
	sudo chown -R 999:docker /mnt/group$weight/logdir
	sudo chown -R 999:docker /mnt/group$weight/conf

	
	sudo docker run \
	--blkio-weight=${weight} \
	--name test$weight \
	-v /mnt/group$weight:/mnt \
	-v /mnt/group$weight/datadir:/var/lib/mysql \
	-v /mnt/group$weight/logdir:/var/log/mysql \
	-v /mnt/group$weight/conf:/etc/mysql/conf.d \
	jonggyupark/mysql:latest &

done

#echo 1 > /sys/fs/bcache/*/clear_stats

wait

echo "cache hit ratio"

cat /sys/fs/bcache/*/stats_total/cache_hit_ratio

#	(cd ../../../bcache && ./drop.sh)


