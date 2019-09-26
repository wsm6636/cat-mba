#!/bin/bash
sudo bash test-cat3.sh $1 $2 > ../result/$3.log
cat ../result/$3.log | grep 'miss' > ../result/log$3.txt
cat ../result/$3.log | grep 'references' >> ../result/log$3.txt
cat ../result/$3.log | grep 'duration' >> ../result/log$3.txt
