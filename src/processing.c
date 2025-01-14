#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "processing.h"
#include "sensor.h"

int calculate_average(const uint16_t *data, int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += data[i];
    }
    return sum / size;
}

void process_data(uint16_t *data) {
    int avg = calculate_average(data, BUFFER_SIZE);
    printf("Average sensor value: %d\n", avg);

    if (avg > 512) {
        printf("Warning: Sensor value exceeds threshold!\n");
    } else {
        printf("Sensor value is within safe range.\n");
    }
}
