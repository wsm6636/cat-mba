#!/bin/bash


for((i=0;i<$1;i++))
do
	{
		sudo ../memtest -m 600 -c $2 -i 1
	}
done > ../result/$3.log

#sudo bash test-cat1.sh $1 $2 > ./result/$3.log
cat ../result/$3.log | grep 'miss' > ../result/log$3.txt
cat ../result/$3.log | grep 'references' >> ../result/log$3.txt
cat ../result/$3.log | grep 'duration' >> ../result/log$3.txt
cat ../result/$3.log | grep 'bandwidth' >> ../result/log$3.txt
