#!/bin/bash
sudo bash cat_set_cos_cdpoff.sh $1 $1 $1 $1 $1 $1 $1 $1
#cd ~/memtest
for((i=0;i<$2;i++))
do
	{
		sudo ../memtest -m 5 -c 0 -i 100
	}
done

#		cd ~/wsm-cat-mba
