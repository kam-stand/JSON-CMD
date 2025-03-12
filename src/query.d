module query;
import parser;
import lexer;
import std.stdio;
import std.algorithm;
import std.range;



void keySummary(ref JSON_OBJECT o, ulong preview = 100)
{
    preview > o.keys.length ?preview = o.keys.length: preview;
    iota(preview).each!(n => writef("%d. %s -> %s\n", n+1, o.keys[n], (o.values[o.keys[n]].type)));
}


