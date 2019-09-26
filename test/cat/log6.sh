#!/bin/bash
for((i=0;i<$2;i++))
do
	{
		sudo ../memtest -m $1 -c 0 -i 100
	}
done > ../result/$3.log

#sudo bash test-cat1.sh $1 $2 > ./result/$3.log
cat ../result/$3.log | grep 'miss' > ../result/log$3.txt
cat ../result/$3.log | grep 'references' >> ../result/log$3.txt
cat ../result/$3.log | grep 'duration' >> ../result/log$3.txt
