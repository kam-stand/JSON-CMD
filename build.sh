ldc2 -w -wi ./src/*.d -of=bin/json && ./bin/json $1


# dmd -wi -vgc -profile=gc  ./src/lexer.d ./src/main.d ./src/parser.d ./src/query.d -of=bin/json    