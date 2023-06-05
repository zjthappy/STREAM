#!/bin/bash
#------------------------------ 
# 测试最佳线程数量 

# 数据量固定为llc大小的8倍

#------------------------------ 


echo -n "请输入最后一级cache大小(MiB):"
read size
llc_size=$(echo "scale=2;$size*1024*1024/8"|bc)

echo -n "请输入测试次数:"
read times

echo -n "请输入测试集是几倍cache大小:"
read multi

echo -n "请输入当前核数:"
read core



thread_count=0

step=2

echo "线程数     Copy       Scale       Add       Triad"

while(( $thread_count<=4*$core ))
do
    thread_count=`expr $thread_count + $step`
    
    export OMP_NUM_THREADS=$thread_count
    
    filesize=$(echo "scale=0;$llc_size*$multi/1"|bc)
    gcc -O3 -fopenmp  -DSTREAM_ARRAY_SIZE=$filesize -DNTIMES=10 ../stream.c -o ../stream

    echo  -n "$thread_count       "
    ../stream  | awk '/^(Copy|Scale|Add|Triad)/ {print $2}' |awk '{printf("%s    ", $0)} END {printf("\n")}' 
    # break
    
    
done
