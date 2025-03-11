module main;

import std.stdio;
import lexer;
import parser;

void main(string[] args)
{

    string file_name = args[1];
    string input = lexer.read_file(file_name);
    auto tokens = lexer.tokenizer(input);
    // foreach (token; tokens)
    // {
    //     writefln("[ %s : '%s' ]", token.type, token.lexeme);
    // }
    int index = 0;
    JSON_OBJECT obj = parser.parseObject(tokens, index);

    //parser.printObj(obj);

    foreach (key; obj.keys)
    {
        write(key, " -> ", obj.values[key].type);

        //parser.printJSONValue(obj.values[key], 1);

        writeln();
    }



}
