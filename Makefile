# Compiler and Flags
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g -std=c99
CXXFLAGS = -Wall -Wextra -g -std=c++11

# Directories
SRC_DIR = src
BUILD_DIR = build
EXTERNAL_DIR = external
GTEST_DIR = $(EXTERNAL_DIR)/googletest
INCLUDE_DIRS = -I$(SRC_DIR) -I$(GTEST_DIR)/googletest/include -I$(GTEST_DIR)/googlemock/include

# Files
SRC_FILES = $(SRC_DIR)/*.c
OBJ_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
TEST_SRC = test/test_main.cpp
TEST_OBJ = $(BUILD_DIR)/test_main.o

# Google Test
GTEST_LIB = $(GTEST_DIR)/build/lib/libgtest.a
GTEST_MAIN_LIB = $(GTEST_DIR)/build/lib/libgtest_main.a

# Targets
TARGET = $(BUILD_DIR)/main
TEST_TARGET = $(BUILD_DIR)/test

# Phony targets
.PHONY: all clean tests cppcheck

# All build (default target)
all: $(TARGET)

# Main program build
$(TARGET): $(OBJ_FILES)
	$(CC) $(OBJ_FILES) -o $@

# Test program build
$(TEST_TARGET): $(OBJ_FILES) $(TEST_OBJ) $(GTEST_LIB) $(GTEST_MAIN_LIB)
	$(CXX) $(OBJ_FILES) $(TEST_OBJ) $(GTEST_LIB) $(GTEST_MAIN_LIB) -o $@

# Compile object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INCLUDE_DIRS) -c $< -o $@

$(BUILD_DIR)/test_main.o: $(TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDE_DIRS) -c $< -o $@

# Google Test setup
$(GTEST_LIB):
	cd $(GTEST_DIR) && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_GTEST=ON -DBUILD_GMOCK=OFF .
	cd $(GTEST_DIR) && make

$(GTEST_MAIN_LIB):
	cd $(GTEST_DIR) && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_GTEST=ON -DBUILD_GMOCK=OFF .
	cd $(GTEST_DIR) && make

# Run tests
tests: $(TEST_TARGET)
	$(TEST_TARGET)

# Static analysis with cppcheck
cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC_DIR) 

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) $(GTEST_DIR)/build
