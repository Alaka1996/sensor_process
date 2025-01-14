# Variables
CC = gcc
CXX = g++
CFLAGS = -Wall -Iinclude -Iexternal/googletest/googletest/include -Wno-unused-function
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

# Source files
SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))
MAIN_OBJ = $(OBJ_DIR)/main.o
UTILS_OBJ = $(OBJ_DIR)/utils.o
SENSOR_OBJ = $(OBJ_DIR)/sensor.o
TEST_OBJ = $(OBJ_DIR)/test_sensor.o

# Google Test flags
CXXFLAGS = -Wall -Iinclude -Iexternal/googletest/googletest/include -Wno-unused-function
LDFLAGS = -Lexternal/googletest/googletest/lib -lgtest -lgtest_main -pthread

# Targets
all: dirs $(BIN_DIR)/sensor_program $(BIN_DIR)/test_sensor

# Create directories
dirs:
	mkdir -p $(OBJ_DIR) $(BIN_DIR)

# Build the main program
$(BIN_DIR)/sensor_program: $(MAIN_OBJ) $(SENSOR_OBJ) $(UTILS_OBJ)
	$(CC) $(CFLAGS) $^ -o $@

# Build the test binary
$(BIN_DIR)/test_sensor: $(TEST_OBJ) $(SENSOR_OBJ) $(UTILS_OBJ)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

# Compile main source file
$(OBJ_DIR)/main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

# Compile test file
$(OBJ_DIR)/test_sensor.o: tests/test_sensor.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile sensor source file
$(OBJ_DIR)/sensor.o: src/sensor.c
	$(CC) $(CFLAGS) -c $< -o $@

# Compile utils source file
$(OBJ_DIR)/utils.o: src/utils.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean build artifacts
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Run Cppcheck
lint:
	cppcheck --force --enable=all --inconclusive --std=c++17 -Iinclude -I/usr/include --suppress=missingIncludeSystem --suppress=syntaxError src/*.c

# Run the tests (Google Test)
test: $(BIN_DIR)/test_sensor
	$(BIN_DIR)/test_sensor

.PHONY: all dirs clean lint debug test
