module lexer;
import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.ascii;

enum TOKEN_TYPE
{
    LEFT_BRACE,
    RIGHT_BRACE,
    LEFT_BRACKET,
    RIGHT_BRACKET,
    COLON,
    COMMA,
    STRING,
    NUMBER,
    BOOLEAN,
    NULL_TOKEN,
    EOF
}

struct TOKEN
{
    TOKEN_TYPE type;
    string lexeme;
}

// Read file contents correctly
string read_file(string file_name)
{
    return cast(string) read(file_name);
}

// Tokenizer function
TOKEN[] tokenizer(ref string contents)
{
    int index = 0;
    TOKEN[] tokens;

    while (index < contents.length)
    {
        char c = contents[index];

        switch (c)
        {
        case '{':
            tokens ~= TOKEN(TOKEN_TYPE.LEFT_BRACE, "{");
            index++;
            break;
        case '}':
            tokens ~= TOKEN(TOKEN_TYPE.RIGHT_BRACE, "}");
            index++;
            break;
        case '[':
            tokens ~= TOKEN(TOKEN_TYPE.LEFT_BRACKET, "[");
            index++;
            break;
        case ']':
            tokens ~= TOKEN(TOKEN_TYPE.RIGHT_BRACKET, "]");
            index++;
            break;
        case ':':
            tokens ~= TOKEN(TOKEN_TYPE.COLON, ":");
            index++;
            break;
        case ',':
            tokens ~= TOKEN(TOKEN_TYPE.COMMA, ",");
            index++;
            break;
        case '"': // String parsing
            tokens ~= lexString(index, contents);
            break;
        case 't', 'f', 'n': // Boolean or null
            tokens ~= lexAlpha(index, contents);
            break;
        default:
            if (isDigit(c) || c == '-') // Number parsing (supporting negatives)
            {
                tokens ~= lexNumber(index, contents);
            }
            else if (isWhite(c)) // Skip whitespace
            {
                index++;
            }
            else
            {
                writeln("Unexpected character: ", c);
                index++;
            }
        }
    }

    tokens ~= TOKEN(TOKEN_TYPE.EOF, "EOF");
    return tokens;
}

TOKEN lexString(ref int index, ref string contents)
{
    index++; // Skip initial quote
    string value = "";

    while (index < contents.length && contents[index] != '"')
    {
        value ~= contents[index];
        index++;
    }

    index++; // Skip closing quote
    return TOKEN(TOKEN_TYPE.STRING, value);
}

TOKEN lexAlpha(ref int index, ref string contents)
{
    string lexeme = "";
    while (index < contents.length && isAlpha(contents[index]))
    {
        lexeme ~= contents[index];
        index++;
    }

    if (lexeme == "true" || lexeme == "false")
        return TOKEN(TOKEN_TYPE.BOOLEAN, lexeme);
    else if (lexeme == "null")
        return TOKEN(TOKEN_TYPE.NULL_TOKEN, lexeme);
    
    return TOKEN(TOKEN_TYPE.STRING, lexeme);
}

TOKEN lexNumber(ref int index, ref string contents)
{
    string num = "";
    bool hasDecimal = false;

    while (index < contents.length && (isDigit(contents[index]) || contents[index] == '.'))
    {
        if (contents[index] == '.')
        {
            if (hasDecimal) break; 
            hasDecimal = true;
        }

        num ~= contents[index];
        index++;
    }

    return TOKEN(TOKEN_TYPE.NUMBER, num);
}
