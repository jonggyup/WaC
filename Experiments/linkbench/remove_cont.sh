#!/bin/bash

#execute 4 container with ycsb benchmarks
for weight in 100 200 400 800
do	
	docker rm test$weight -f
done
