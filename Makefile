# Compiler and flags
CC = gcc
CFLAGS = -Iinclude -Wall -Wextra -std=c99

# Google Test settings
GTEST_DIR = /usr/src/gtest
GTEST_LIB = /usr/lib/libgtest.a
GTEST_MAIN = /usr/lib/libgtest_main.a

# Source files and object files
SRC = src/main.c src/sensor.c src/processing.c src/utils.c
OBJ = $(SRC:.c=.o)
TARGET = sensor_program

# Test files and object files
TEST_SRC = tests/test_main.c tests/test_sensor.c
TEST_OBJ = $(TEST_SRC:.c=.o)
TEST_TARGET = test_program

# Default target
all: $(TARGET)

# Build the program
$(TARGET): $(OBJ)
	$(CC) -o $@ $^

# Build and run tests
$(TEST_TARGET): $(TEST_OBJ) $(GTEST_LIB) $(GTEST_MAIN)
	$(CC) $(CFLAGS) -o $@ $^ -lgtest -lgtest_main -pthread

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Run cppcheck for static code analysis
cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC)

# Clean up build files
clean:
	rm -f $(OBJ) $(TARGET) $(TEST_OBJ) $(TEST_TARGET)
