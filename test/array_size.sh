#!/bin/bash
#------------------------------ 
# 单线程 测试最佳数组大小
#L1d 缓存：                       288 KiB
#L1i 缓存：                       192 KiB
#L2 缓存：                        7.5 MiB
#------------------------------ 

#!/bin/bash

echo -n "请输入最后一级cache大小(MiB):"
read size
llc_size=$(echo "scale=2;$size*1024*1024/8"|bc)

echo -n "请输入测试次数:"
read times

step=0.5

multi=0

echo "数组大小  cache的倍数     Copy       Scale       Add       Triad"
while(( $(echo "$multi<=10" | bc) ))
do
    multi=$(echo "$multi+$step"|bc) 
    filesize=$(echo "scale=0;$llc_size*$multi/1"|bc)
    gcc -O3  -DSTREAM_ARRAY_SIZE=$filesize -DNTIMES=$times ../stream.c -o ../stream

    echo  -n "$filesize      $multi          "
    ../stream | awk '/^(Copy|Scale|Add|Triad)/ {print $2}' |awk '{printf("%s    ", $0)} END {printf("\n")}' 
    
done

