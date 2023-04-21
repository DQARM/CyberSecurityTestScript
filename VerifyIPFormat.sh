
#!/bin/bash
 
# 定义一个正则表达式，匹配四个数字和三个点的组合
regex='([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)'
 
# 读取文件中的每一行
while read line; do
  # 如果行匹配正则表达式
  if [[ $line =~ $regex ]]; then
    # 获取匹配的四个数字
    a=${BASH_REMATCH[1]}
    b=${BASH_REMATCH[2]}
    c=${BASH_REMATCH[3]}
    d=${BASH_REMATCH[4]}
    # 检查每个数字是否在 0 到 255 的范围内
    if [ $a -ge 0 -a $a -le 255 -a $b -ge 0 -a $b -le 255 -a $c -ge 0 -a $c -le 255 -a $d -ge 0 -a $d -le 255 ]; then
      if [[ $line == *"/"* ]]; then
        echo "$line is a Subnet"
      elif [ $a -eq 0 -o $a -eq 127 -o $a -eq 10 ]; then
        echo "$line is a Reserved Address"      
      else
        # 如果是，打印合法的 IP 地址
        echo "$line is a valid IP address"
      fi
    else
      # 如果不是，打印不合法的 IP 地址
      echo "$line is not a valid IP address"
    fi
  else
    # 如果行不匹配正则表达式，打印不合法的 IP 地址
    echo "$line is not a valid IP address"
  fi
done < IP_Total.txt 


