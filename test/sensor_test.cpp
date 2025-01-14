extern "C" { 
    // Include your C function declarations here
    #include "sensor.h"  // Include your C headers
    #include "processing.h"
}

#include <gtest/gtest.h>

// Test case for calculate_average
TEST(SensorTest, CalculateAverage) {
    uint16_t data[] = {100, 200, 300, 400, 500};
    int size = 5;
    int result = calculate_average(data, size);
    EXPECT_EQ(result, 300);
}

// Test case for read_sensor_data
TEST(SensorTest, ReadSensorData) {
    uint16_t data[10] = {0};
    read_sensor_data(data);
    for (int i = 0; i < 10; ++i) {
        EXPECT_GE(data[i], 0);
        EXPECT_LT(data[i], 1024);
    }
}
