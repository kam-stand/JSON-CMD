module main;

import std.stdio;
import lexer;
import parser;
import core.stdc.stdlib;
import query;

void main(string[] args)
{

    string file_name = args[1];
    string input = lexer.read_file(file_name);
    auto tokens = lexer.tokenizer(input);
    int index = 0;
    JSON_OBJECT obj = parser.parseObject(tokens, index);

    while (1)
    {
        writeln("Please enter what you would like to analyze");
        writeln("USAGE: [1] key summary [2] print key value");
        int ans;
        readf("%d\n", &ans);
        if (ans == 1)
        {
            query.keySummary(obj, 1_0000);

        }
        else if (ans == 2)
        {

            writeln("Please enter key: ");
            string key;
            readf("%s\n", &key);
            query.printValue(key, obj);

        }
        else if (ans == 0)
        {
            break;
        }

    }
}
