// language-of-dice interpreter

#include "eventstats.h"

#include <cstdio>
#include <cstdlib>
#include <string>
#include <fstream>
#include <sstream>
#include <ctime>
using namespace std;

string load_script(char * filename);

int main(int argc, char ** argv){
    if (argc != 2){
        return 1; 
    }
    srand(time(0));
    string script = load_script(argv[1]);
    return 0;
}

string load_script(char * filename){
    ifstream t(filename);
    stringstream ss;
    ss << t.rdbuf();
    string script = ss.str();
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
