src="./src/*.d"
bin="./bin/json"

ldc2 -w $src -of=$bin

$bin

