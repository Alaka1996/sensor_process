#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "utils.h"

void print_data(const uint16_t *data, int size) {
    for (int i = 0; i < size; i++) {
        printf("Sensor Data[%d]: %d\n", i, data[i]);
    }
}
