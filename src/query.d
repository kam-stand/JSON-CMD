module query;
import parser;
import lexer;
import std.stdio;
import std.algorithm;
import std.range;



void keySummary(ref JSON_OBJECT obj, ulong preview = 100)
{
    preview > obj.keys.length ?preview = obj.keys.length: preview;
    iota(preview).each!(n => writef("%d. %s -> %s\n", n+1, obj.keys[n], (obj.values[obj.keys[n]].type)));
}


void printValue(string key, JSON_OBJECT obj)
{
    parser.printJSONValue(obj.values[key], 1);

}


