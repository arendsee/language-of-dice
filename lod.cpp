// language-of-dice interpreter

#include "eventstats.h"
#include "tokenizer.h"

#include <cstdio>
#include <cstdlib>
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>
#include <ctime>
#include <vector>

std::string load_script(char * filename);

int main(int argc, char ** argv){
    if (argc != 2){
        return 1; 
    }
    std::srand(time(0));
    std::string script = load_script(argv[1]);

    std::vector<std::string> v = get_tokens(script);
    for(int i = 0; i < v.size(); i++){
        std::cout << v[i] << ' ';
    }
    std::cout << std::endl;

    return 0;
}

std::string load_script(char * filename){
    std::ifstream t(filename);
    std::stringstream ss;
    ss << t.rdbuf();
    std::string script = ss.str();
    return script;
}
    
/*
    // test script for stat functions
    unsigned int num;
    unsigned int sides;
    sscanf(script.c_str(), "%dd%d", &num, &sides);

    printf("%f\n", roll_avg(num, sides));

    const unsigned int size = sides * num;
    float * density = new float[size];
    roll_density(sides, num, density, size);
    for(unsigned int i = 0; i < size; i++){
        printf("%d\t%f\n", i+1, density[i]);
    }
*/
