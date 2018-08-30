while true; do 
	echo -ne "HTTP/1.1 200 OK\r\nContent-Length:$(wc -c < ~/enigma-contract/enigmacontract.txt)\r\n\r\n$(cat ~/enigma-contract/enigmacontract.txt)" | nc -l -p 8081
done
