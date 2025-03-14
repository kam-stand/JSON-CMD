module parser;
import std.stdio;
import lexer;
import std.conv : to;
import std.string;

enum JSON_TYPE
{
	JSON_OBJECT, // {}
	JSON_ARRAY, // []
	JSON_STRING, // "text"
	JSON_NUMBER, // 123.45
	JSON_BOOLEAN, // true / false
	JSON_NULL // null
}

struct JSON_OBJECT
{
	JSON_TYPE type;
	string[] keys;
	JSON_VALUE[string] values;
}

struct JSON_ARRAY
{
	JSON_TYPE type;
	JSON_VALUE[] values;
}

struct JSON_VALUE
{
	JSON_TYPE type;
	union
	{
		string str_val;
		double num_val;
		bool bool_val;
		JSON_OBJECT obj;
		JSON_ARRAY arr;
	}
}

JSON_OBJECT parseObject(ref TOKEN* tokens, ref int index)
{
	JSON_OBJECT obj;
	index++; // pass the right bracket
	while (tokens[index].type != TOKEN_TYPE.RIGHT_BRACE)
	{
		assert(tokens[index].type == TOKEN_TYPE.STRING);
		string key = tokens[index].lexeme;
		obj.keys ~= key;
		index++; // at colon
		assert(tokens[index].type == TOKEN_TYPE.COLON);
		index++;
		JSON_VALUE value;
		if (tokens[index].type == TOKEN_TYPE.STRING)
		{
			value.type = JSON_TYPE.JSON_STRING;
			value.str_val = tokens[index].lexeme;
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.NUMBER)
		{
			value.type = JSON_TYPE.JSON_NUMBER;
			value.num_val = to!double(tokens[index].lexeme);
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.BOOLEAN)
		{
			value.type = JSON_TYPE.JSON_BOOLEAN;
			value.bool_val = to!bool(tokens[index].lexeme);
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.NULL_TOKEN)
		{
			value.type = JSON_TYPE.JSON_NULL;
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.LEFT_BRACE)
		{
			value.type = JSON_TYPE.JSON_OBJECT;
			value.obj = parseObject(tokens, index);
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.LEFT_BRACKET)
		{
			value.type = JSON_TYPE.JSON_ARRAY;
			value.arr = parseArray(tokens, index);
			index++;
		}
		obj.values[key] = value;
		if (tokens[index].type == TOKEN_TYPE.COMMA)
		{
			index++;
		}
	}
	return obj;
}

JSON_ARRAY parseArray(ref TOKEN* tokens, ref int index)
{
	JSON_ARRAY array;
	index++;
	while (tokens[index].type != TOKEN_TYPE.RIGHT_BRACKET)
	{
		JSON_VALUE value;
		if (tokens[index].type == TOKEN_TYPE.STRING)
		{
			value.type = JSON_TYPE.JSON_STRING;
			value.str_val = tokens[index].lexeme;
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.NUMBER)
		{
			value.type = JSON_TYPE.JSON_NUMBER;
			value.num_val = to!double(tokens[index].lexeme);
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.BOOLEAN)
		{
			value.type = JSON_TYPE.JSON_BOOLEAN;
			value.bool_val = to!bool(tokens[index].lexeme);
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.NULL_TOKEN)
		{
			value.type = JSON_TYPE.JSON_NULL;
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.LEFT_BRACE)
		{
			value.type = JSON_TYPE.JSON_OBJECT;
			value.obj = parseObject(tokens, index);
			index++;
		}
		else if (tokens[index].type == TOKEN_TYPE.LEFT_BRACKET)
		{
			value.type = JSON_TYPE.JSON_ARRAY;
			value.arr = parseArray(tokens, index);
			index++;
		}
		array.values ~= value;
		if (tokens[index].type == TOKEN_TYPE.COMMA)
		{
			index++;
		}
	}
	return array;

}

string indent(int level, string indentString = "  ")
{
	string result = "";
	for (int i = 0; i < level; ++i)
	{
		result ~= indentString;
	}
	return result;
}

void printJSONValue(in JSON_VALUE value, int indentLevel = 0)
{
	string indentation = indent(indentLevel);

	switch (value.type)
	{
	case JSON_TYPE.JSON_NUMBER:
		write(value.num_val);
		break;
	case JSON_TYPE.JSON_STRING:
		write('"', value.str_val, '"');
		break;
	case JSON_TYPE.JSON_BOOLEAN:
		write(value.bool_val ? "true" : "false");
		break;
	case JSON_TYPE.JSON_NULL:
		write("null");
		break;
	case JSON_TYPE.JSON_OBJECT:
		writeln("{");
		foreach (key, val; value.obj.values)
		{
			write(indent(indentLevel + 1), '"', key, "\": ");
			printJSONValue(val, indentLevel + 1);
			writeln(",");
		}
		if (value.obj.values.length > 0)
		{
			write(indentation, "}");
		}
		else
		{
			writeln(indentation, "{}");
		}
		break;
	case JSON_TYPE.JSON_ARRAY:
		writeln("[");
		foreach (val; value.arr.values)
		{
			write(indent(indentLevel + 1));
			printJSONValue(val, indentLevel + 1);
			writeln(",");
		}
		if (value.arr.values.length > 0)
		{
			writeln(indentation, "]");
		}
		else
		{
			writeln(indentation, "[]");
		}
		break;
	default:
		writeln("Unknown JSON type");
		break;
	}
}

void printObj(in JSON_OBJECT obj)
{
	writeln("{");
	foreach (key, val; obj.values)
	{
		write(indent(1), '"', key, "\": ");
		printJSONValue(val, 1);
		writeln(",");
	}
	if (obj.values.length > 0)
	{
		writeln("}");
	}
	else
	{
		writeln("{}");
	}
}
