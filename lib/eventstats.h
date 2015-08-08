#ifndef EVENTSTATS_H
#define EVENTSTATS_H

unsigned int roll(
    unsigned int num,
    unsigned int sides);

float roll_avg(
    unsigned int num,
    unsigned int sides);

void roll_density(
    unsigned int num,
    unsigned int sides,
    float * density,
    unsigned int size);

#endif
