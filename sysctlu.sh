#!/bin/bash

if [ -z $1 ];
then
	VAL_NET_CORE_WMEM_MAX=10485760
	VAL_NET_CORE_RMEM_MAX=10485760
	VAL_NET_IPV4_TCP_WMEM="4096 16384 10485760"
	VAL_NET_IPV4_TCP_RMEM="4096 87380 10485760"
	VAL_NET_IPV4_ROUTE_FLUSH=0
else
	MAXBUF=$1
	VAL_NET_CORE_WMEM_MAX=$MAXBUF
	VAL_NET_CORE_RMEM_MAX=$MAXBUF
	VAL_NET_IPV4_TCP_WMEM=`echo "4096 $(($MAXBUF/2)) $MAXBUF"`
	VAL_NET_IPV4_TCP_RMEM=$VAL_NET_IPV4_TCP_WMEM
	VAL_NET_IPV4_ROUTE_FLUSH=1
fi

replace_insert() {
# Replace in file.conf
# $1 - путь к файлу
FILE=$1
# $2 - праметр
PARAM=$2
# $3 - новое значение
VAL=$3

# echo "$(grep -c $PARAM $FILE)"

if [[ $(grep -c ^$PARAM $FILE) -gt 0 ]] && [[ $(grep -Po '^${PARAM}*=*\K.*' $FILE) != $VAL ]];
      then
          echo "replace $(grep ^${PARAM} ${FILE}) to ${PARAM}=${VAL} in file ${FILE}"
          sed -i "s/\(^${PARAM} *= *\).*/\1${VAL}/" ${FILE}
  elif [ $(grep -c ^$PARAM $FILE) = 0 ];
      then
	      echo "insert ${PARAM} in file ${FILE}"    
          echo "${PARAM}=${VAL}" >> ${FILE}  
fi
}

parametres=("net.core.wmem_max" "net.core.rmem_max" "net.ipv4.tcp_wmem" "net.ipv4.tcp_rmem" "net.ipv4.route.flush")
value=("${VAL_NET_CORE_WMEM_MAX}" "${VAL_NET_CORE_RMEM_MAX}" "${VAL_NET_IPV4_TCP_WMEM}" "${VAL_NET_IPV4_TCP_RMEM}" "${VAL_NET_IPV4_ROUTE_FLUSH}")

for i in ${!parametres[@]};
  do
    echo 
	echo "${parametres[$i]}=${value[$i]}"
        replace_insert /etc/sysctl.conf "${parametres[$i]}" "${value[$i]}"
  done
  echo
echo
echo
echo

sysctl -p
