#!/bin/bash

if [ "$1" != "" ]; then
    NUM_WORKERS=$1

    if [ $NUM_WORKERS -gt 1 ]; then

        # Trivial check if network is running
        if [ -z "$(ps -o command | grep '^docker-compose' | grep up)" ]; then
            echo "Enigma Docker Network does not seem to be up and running."
            echo "Start Enigma Docker Network first with \"launch.bash\""
            echo "Aborting."
            exit 1
        fi

        ARGF="-f docker-compose.yml"

        # Check if network is running in 'development' mode
        if [ -n "$(ps -o command | grep '^docker-compose' | grep up | grep develop)" ]; then
            ARGF="$ARGF -f docker-compose.develop.yml"
            DEVELOP=True;
        fi

        source .env
        if [ "$SGX_MODE" = "HW" ]; then
            ARGF="$ARGF -f docker-compose.hw.yml"
            if [ ! $DEVELOP ]; then
                ARGF="$ARGF -f docker-compose.override.yml"
            fi
        fi

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
