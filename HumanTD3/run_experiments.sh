#!/bin/bash

# Script to reproduce results

for ((i=0;i<10;i+=1))
do 
	python main.py \
	--policy "HumanTD3" \
	--env "Hopper-v2" \
	--seed $i

	python main.py \
	--policy "TD3" \
	--env "Hopper-v2" \
	--seed $i
done
