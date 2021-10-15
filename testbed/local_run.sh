#!/bin/bash
trap kill_test SIGINT

pids=""
function kill_test() {
	echo "STOP"
	for pid in $pids; do
		echo "Kill $pid"
		kill $pid
	done
}


# if [ "$#" -lt 1 ]; then
# 	echo "Usgae ./local_run.sh num_msg<int>"
# 	exit 0
# fi

#num_msg=$1

ip=127.0.0.1
ingress_port=40000
service_port=40001

cd ../images/hyper_images/service_image/service/
cargo run $ip:${service_port} &
pid="$!"
pids="$pids $pid"
echo "run service $pid"
sleep 0.1

cd ../../service_image/service
cargo run $ip:${ingress_port} $ip:${service_port} $ip:${service_port}&
pid="$!"
pids="$pids $pid"
echo "run ingress $pid"

# curl: curl --request POST --data "test123"  http://127.0.0.1:40000/run

# collect data
#echo RUN. tcpdump -i lo "port ${ingress_port} or ${wordcount_port} or ${reverse_port}" -x > record

sleep 10000

#i=0
#for (( i=0; i<${num_msg}; i++ )); do
	#curl --header "Content-Type: application/json" --request POST --data '{"text":"test test","mid":"'$i'"}' http://$ip:$ingress_port/run
	#sleep 0.5
#done

kill_test

