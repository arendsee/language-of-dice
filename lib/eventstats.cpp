#define BASE_TRIALS 10000

#include <cstdlib>
#include <cmath>
using namespace std;

unsigned int roll(unsigned int num, unsigned int sides){
    unsigned int sum = 0;
    for(unsigned int i = 0; i < num; i++){
        sum += rand() % sides + 1;
    }
    return sum;
}

float roll_avg(unsigned int num, unsigned int sides){
    unsigned int total = 0;
    for(unsigned int t = 0; t < BASE_TRIALS; t++){
        unsigned int sum = 0;
        for(unsigned int i = 0; i < num; i++){
            sum += rand() % sides + 1;
        }
        total += sum;
    }
    float avg = float(total) / BASE_TRIALS;
    return avg;
}

void roll_density(unsigned int num, unsigned int sides, float * density, unsigned int size){
    unsigned int trials = BASE_TRIALS * size;

    // TODO pull this out in a function
    for(unsigned int i = 0; i < size; i++){
        density[i] = 0;
    }

    for(unsigned int t = 0; t < trials; t++){
        unsigned int sum = 0;
        for(unsigned int i = 0; i < num; i++){
            sum += rand() % sides + 1;
        }
        density[sum]++;
    }

    for(unsigned int i = 0; i < size; i++){
        density[i] /= trials;
    }
}
