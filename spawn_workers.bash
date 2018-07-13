#!/bin/bash

if [[ "$DEVELOP" -eq 1 ]]; then
    echo "Launching Docker Enigma Network in development mode..."
    ARGF="-f docker-compose.develop.yml"
    SRFD="~/wrapper-develop.bash &&"
else
    ARGF=""
    SRFD=""
fi

if [ "$1" != "" ]; then
    NUM_WORKERS=$1

    if [ $NUM_WORKERS -gt 1 ]; then
    	for i in $(seq 2 $NUM_WORKERS); do
            WORKER_INDEX=$i docker-compose $ARGF scale core=$i
            YCOORD=$(expr 20 + 350 \* $(expr $i - 1))
            xterm -T "Enigma Core $i" -geometry 120x20+600+$YCOORD -e "docker attach enigma_core_$i" &

            WORKER_INDEX=$i docker-compose $ARGF scale surface=$i
            YCOORD=$(expr $YCOORD + 60)
            xterm -T "Enigma Surface $i" -geometry 120x20+900+$YCOORD -e "docker-compose exec --index=$i surface bash -c \"$SRFD ./wait_launch.bash; bash\"" &

    	done
    fi

else
	echo "Specify the number of workers with:"
    echo "./spawn_workers N"
    echo "where is N is a number greater than 1"
fi
