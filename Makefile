# Compiler and flags
CC = gcc
CXX = g++
CFLAGS = -Iinclude -Wall -Wextra -std=c99
CXXFLAGS = -Iinclude -std=c++11 -Wall

# Source files and object files
SRC = src/main.c src/sensor.c src/processing.c src/utils.c
OBJ = $(SRC:.c=.o)
TARGET = sensor_program

# Test files
TEST_SRC = test/sensor_test.cpp
TEST_OBJ = $(TEST_SRC:.cpp=.o)
TEST_TARGET = test_program

# Default target
all: $(TARGET)

# Build the program
$(TARGET): $(OBJ)
	$(CC) -o $@ $^

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Compile test files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Run cppcheck for static analysis
cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC)

# Build and run tests with Google Test
test: $(OBJ) $(TEST_OBJ)
	$(CXX) -o $(TEST_TARGET) $^ -lgtest -lgtest_main -pthread
	./$(TEST_TARGET)

# Clean up build files
clean:
	rm -f $(OBJ) $(TARGET) $(TEST_OBJ) $(TEST_TARGET)

