#parse one_line_data to readble list

STR="server1, server2, server3"
 
 IFS=', ' read -ra NAMES <<< "$STR"    #Convert string to array
 
   #Print all names from array
 for i in "${NAMES[@]}"; do
     echo $i
 done
