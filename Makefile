# Compiler and flags
CC = gcc
CXX = g++
CFLAGS = -Wall -g -std=c99
CXXFLAGS = -Wall -g -std=c++11
LDFLAGS = -pthread

# Directories
SRC_DIR = src
BUILD_DIR = build
GTEST_DIR = external/googletest
GTEST_LIB_DIR = $(GTEST_DIR)/lib
GTEST_INCLUDE_DIR = $(GTEST_DIR)/googletest/include

# Source files
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
EXEC = $(BUILD_DIR)/main
TEST_EXEC = $(BUILD_DIR)/test_main

# Targets
.PHONY: all clean build tests cppcheck run_tests gtest

all: $(EXEC) tests

# Build main executable
$(EXEC): $(OBJ_FILES)
	$(CC) $(OBJ_FILES) -o $(EXEC) $(LDFLAGS)

# Build Google Test from submodule
gtest:
	cd $(GTEST_DIR) && cmake . && make

# Run the tests
tests: gtest $(TEST_EXEC)
	$(TEST_EXEC)

# Build the tests
$(TEST_EXEC): $(OBJ_FILES) $(BUILD_DIR)/test_main.o
	$(CXX) $(OBJ_FILES) $(BUILD_DIR)/test_main.o -o $(TEST_EXEC) -lgtest -lgtest_main $(LDFLAGS)

# Compile test main
$(BUILD_DIR)/test_main.o: test/test_main.cpp
	$(CXX) $(CXXFLAGS) -I$(GTEST_INCLUDE_DIR) -c $< -o $@

# Compile source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Run cppcheck static analysis
cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 --force $(SRC_DIR)

# Clean the build
clean:
	rm -rf $(BUILD_DIR) $(EXEC) $(TEST_EXEC)
