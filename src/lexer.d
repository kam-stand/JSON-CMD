module lexer;
import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.ascii;
import core.stdc.stdlib;
import core.stdc.stdio;

enum DEFAULT_SIZE = 100_000;

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
TOKEN* tokenizer(ref string contents)@nogc
{
    int index = 0;
    TOKEN* tokens = cast(TOKEN *)malloc(TOKEN.sizeof * DEFAULT_SIZE);
    int current = 0;


    while (index < contents.length)
    {
        char c = contents[index];
        if (current == DEFAULT_SIZE)
        {
          realloc(tokens, DEFAULT_SIZE * 2);   
        }

        switch (c)
        {
        case '{':
            tokens[current++] = TOKEN(TOKEN_TYPE.LEFT_BRACE, "{");
            index++;
            break;
        case '}':
            tokens[current++]= TOKEN(TOKEN_TYPE.RIGHT_BRACE, "}");
            index++;
            break;
        case '[':
            tokens[current++]= TOKEN(TOKEN_TYPE.LEFT_BRACKET, "[");
            index++;
            break;
        case ']':
            tokens[current++]= TOKEN(TOKEN_TYPE.RIGHT_BRACKET, "]");
            index++;
            break;
        case ':':
            tokens[current++]= TOKEN(TOKEN_TYPE.COLON, ":");
            index++;
            break;
        case ',':
            tokens[current++]= TOKEN(TOKEN_TYPE.COMMA, ",");
            index++;
            break;
        case '"': // String parsing
            tokens[current++]= lexString(index, contents);
            break;
        case 't', 'f', 'n': // Boolean or null
            tokens[current++]= lexAlpha(index, contents);
            break;
        default:
            if (isDigit(c) || c == '-') // Number parsing (supporting negatives)
            {
                tokens[current++]= lexNumber(index, contents);
            }
            else if (isWhite(c)) // Skip whitespace
            {
                index++;
            }
            else
            {
                printf("Unexpected character: ", c);
                index++;
            }
        }
    }

    tokens[current++] = TOKEN(TOKEN_TYPE.EOF, "EOF");
    return tokens;
}

TOKEN lexString(ref int index, ref string contents) @nogc
{

     index++; // Skip initial quote
    auto start = index;

    while (index < contents.length && contents[index] != '"')
    {
        index++;
    }

    auto value = contents[start .. index]; // Slice avoids allocation
    index++; // Skip closing quote
    return TOKEN(TOKEN_TYPE.STRING, value);
}

TOKEN lexAlpha(ref int index, ref string contents) @nogc
{

    auto start = index;

    while (index < contents.length && isAlpha(contents[index]))
    {
        index++;
    }

    auto lexeme = contents[start .. index]; // Slice instead of concatenation

    if (lexeme == "true" || lexeme == "false")
        return TOKEN(TOKEN_TYPE.BOOLEAN, lexeme);
    else if (lexeme == "null")
        return TOKEN(TOKEN_TYPE.NULL_TOKEN, lexeme);

    return TOKEN(TOKEN_TYPE.STRING, lexeme);
}

TOKEN lexNumber(ref int index, ref string contents) @nogc
{
    auto start = index;
    bool hasDecimal = false;

    while (index < contents.length && (isDigit(contents[index]) || contents[index] == '.'))
    {
        if (contents[index] == '.')
        {
            if (hasDecimal) break;
            hasDecimal = true;
        }
        index++;
    }

    auto num = contents[start .. index]; // Slice avoids allocation
    return TOKEN(TOKEN_TYPE.NUMBER, num);
}
