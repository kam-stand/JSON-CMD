module main;

import std.stdio;
import lexer;
import parser;
import query;

void main(string[] args)
{

    string file_name = args[1];
    string input = lexer.read_file(file_name);
    auto tokens = lexer.tokenizer(input);
    int index = 0;
    JSON_OBJECT obj = parser.parseObject(tokens, index);

    query.keySummary(obj, 1000);
}
