#!/bin/bash
sudo bash cat-set__COS_All.sh $1 $1 $1 $1 $1 $1 $1 $1
#cd ~/memtest
for((i=0;i<$2;i++))
do
	{
		sudo ../memtest -m 5 -c 0 -i 100
	}
done

#		cd ~/wsm-cat-mba
