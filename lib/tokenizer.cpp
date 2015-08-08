#include <vector>
#include <string>
#include <iostream>

bool is_alphabetic(char c);
bool is_numeric(char c);

std::vector<std::string> get_tokens(std::string script){
    std::vector<std::string> tokens;
    bool in_comment = false;
    for(int i = 0; i < script.length(); i++){
        char c = script[i];
        char cn = script[i+1];

        if(in_comment){
            if(c == '\n')
                in_comment = false;
            continue;
        }

        switch(c){
            case ' '  : break;
            case '\t' : break;
            case '\n' : break;
            case '#'  : in_comment = true;          break;
            case '('  : tokens.push_back("L_RPAR"); break;
            case ')'  : tokens.push_back("R_RPAR"); break;
            case '{'  : tokens.push_back("L_CPAR"); break;
            case '}'  : tokens.push_back("R_CPAR"); break;
            case '.'  : if(!is_numeric(cn)){
                            tokens.push_back("LAST_RESULT");
                        } else {
                            std::cerr << "Decimals are not allowed\n";
                        }
                        break;
            case '='  : if(cn == '='){
                            tokens.push_back("EQ");
                            i++;
                        } else {
                            tokens.push_back("DEC_CON");
                        }
                        break;
            case '/'  : if(cn == '='){
                            tokens.push_back("ASSIGN_DIV");
                            i++;
                        } else{
                             tokens.push_back("DIV");
                        }
                        break;
            case '*'  : if(cn == '='){
                            tokens.push_back("ASSIGN_MUL");
                            i++;
                        } else{
                             tokens.push_back("MUL");
                        }
                        break;
            case '%'  : if(cn == '='){
                            tokens.push_back("ASSIGN_MOD");
                            i++;
                        } else{
                            tokens.push_back("MOD");
                        }
                        break;
            case '+'  : if(cn == '+'){
                            tokens.push_back("INCR");     
                            i++;
                        }
                        else if(cn == '='){
                            tokens.push_back("ASSIGN_ADD");     
                            i++;
                        }
                        else{
                            tokens.push_back("ADD"); 
                        }
                        break;
            case '-'  : if(cn == '-'){
                            tokens.push_back("DECR");     
                            i++;
                        }
                        else if(cn == '='){
                            tokens.push_back("ASSIGN_SUB");     
                            i++;
                        }
                        else{
                            tokens.push_back("SUB"); 
                        }
                        break;
            case ':'  : if(cn == '='){
                            tokens.push_back("DEC_RAN"); 
                            i++;
                            break;
                        }
            case '>'  : if(cn == '='){
                            tokens.push_back("GE");
                            i++;
                        } else {
                            tokens.push_back("GT");
                        }
                        break;
            case '<'  : if(cn == '='){
                            tokens.push_back("LE");
                            i++;
                        } else {
                            tokens.push_back("LT");
                        }
                        break;
            case '!'  : if(cn == '='){
                            tokens.push_back("NE"); 
                            i++;
                            break;
                        }
            // If none of the above cases match, this must be a variable name, keyword, or mistake
            default :
                // If it starts with a number, it mist be an INT or a DICE (e.g. 10d12)
                if(is_numeric(c)){
                    while(i++ < script.length() && is_numeric(script[i])) {}
                    i--;

                    if(script[i] == 'd'){
                        if(i++ < script.length() && is_numeric(script[i])){
                            tokens.push_back("DICE");
                            while(i < script.length() && is_numeric(script[i])) i++;
                        }
                        i--;
                    } else {
                        tokens.push_back("INT");
                    }
                }
                // If it starts with a character, it must be a variable name or keyword
                else if(is_alphabetic(c)){
                    std::string word;
                    word.append(1, c);

                    i++;
                    while(i < script.length() && is_alphabetic(script[i])){
                        word.append(1, script[i]);
                        i++;
                    }
                    i--;

                    if(word == "true" || word == "false")
                        tokens.push_back("BOOL"); 
                    else if(word == "while"   ) tokens.push_back("WHILE"   );
                    else if(word == "done"    ) tokens.push_back("DONE"    );
                    else if(word == "break"   ) tokens.push_back("BREAK"   );
                    else if(word == "continue") tokens.push_back("CONTINUE");
                    else if(word == "and"     ) tokens.push_back("AND"     );
                    else if(word == "not"     ) tokens.push_back("NOT"     );
                    else if(word == "yield"   ) tokens.push_back("YIELD"   );
                    else
                        tokens.push_back("VAR");  
                }
                else {
                    std::cerr << "Improper character: " << c << std::endl;
                }
            }
        }
    return tokens;
}

bool is_alphabetic(char c){
    return
    // lowercase letter (95-122)
    (c > 96 && c < 123) ||
    // or uppercase letter (65-90)
    (c > 64 && c < 91) ||
    // or underscore
    c == '_';
}

bool is_numeric(char c){
    return (c > 47 && c < 58);
}
