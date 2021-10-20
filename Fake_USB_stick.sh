#!/bin/bash

# Création des fichiers de 1Mo et leurs hash

declare -A tab

device="sdc"

chemin='/media/daniel/0A92-055B'

sectors=$(cat /sys/block/${device}/size)

bs=$(cat /sys/block/${device}/queue/logical_block_size)

total_size=$(( $sectors * $bs ))

total_size=$(( $total_size / 1024 ))

total_size=$(( $total_size / 1024 ))

for (( i=0; i <= ${total_size}; i++ ))
do
  s_file=$(( $i + 1024 ))
  
  fallocate -l ${s_file}K ${chemin}/Test_$i && sync
  
  tab["Test_$i"]=$(md5sum ${chemin}/Test_$i | awk '{print $1}')

  cd ${chemin}
  
  for item in Test_*
  do
    old_test=${tab[$item]}
    new_test=$(md5sum $item | awk '{print $1}')
    
    if [[ $old_test != $new_test ]]
    then
      echo "Taille réel : $(du -sh $chemin)"
      exit 1
    fi
  done 
done

