while true; do 
	echo -ne "HTTP/1.1 200 OK\r\nContent-Length:$(wc -c < ~/enigma-contract/enigmatokencontract.txt)\r\nAccess-Control-Allow-Origin: *\r\n\r\n$(cat ~/enigma-contract/enigmatokencontract.txt)" | nc -l -p 8082 -q 1
done
