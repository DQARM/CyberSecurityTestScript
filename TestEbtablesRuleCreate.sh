#!/bin/bash


# 遍歷文件的每一行

while IFS= read -r line

do

  # 獲取第一列作為IP地址

  ip=$(echo "$line" | cut -d ',' -f 1)

  # ping IP地址並打印結果

  ping -c 1 "$ip" | grep 'bytes from' || echo "$ip is not reachable"

  # 如果ping成功，則ssh到遠端設備並檢查ebtable

  if [ $? -eq 0 ]; then

    # 使用expect工具來處理ssh的密碼輸入

    # 獲取ebtables的輸出並判斷是否包含IP地址

    output=$(expect -c "

    spawn ssh user@$ip

    expect \"?assword:\"

    send \"password\r\"

    expect \"#\"

    send \"ebtables -L\r\"

    expect \"#\"

    send \"exit\r\"

    " | grep 'ebtables')

    if [[ $output == *"$ip"* ]]; then

      echo "$ip:Y" >> log.txt # 如果包含，則記錄Y到LOG文件

    else

      echo "$ip:N" >> log.txt # 如果不包含，則記錄N到LOG文件

    fi

  fi

done < IP_total.txt

# 刪除臨時文件


