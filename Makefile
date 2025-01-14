# Define variables
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g -std=c99
CXXFLAGS = -Wall -Wextra -g
GTEST_DIR = external/googletest
GTEST_LIB = $(GTEST_DIR)/build/lib/libgtest.a
BUILD_DIR = build
SRC_DIR = src
TEST_DIR = test
INCLUDE_DIR = include
CPP_CHECK = cppcheck

# Define source files and target executable
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES = $(SRC_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
TEST_SRC_FILES = $(wildcard $(TEST_DIR)/*.cpp)
TEST_OBJ_FILES = $(TEST_SRC_FILES:$(TEST_DIR)/%.cpp=$(BUILD_DIR)/%.o)
TARGET = $(BUILD_DIR)/main
TEST_TARGET = $(BUILD_DIR)/test

# Set include directories for the project and GoogleTest
INCLUDES = -I$(INCLUDE_DIR) -I$(GTEST_DIR)/googletest/include -I$(GTEST_DIR)/googlemock/include

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Build the executable
$(TARGET): $(OBJ_FILES)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ_FILES)

# Build the test executable
$(TEST_TARGET): $(TEST_OBJ_FILES) $(GTEST_LIB)
	$(CXX) $(CXXFLAGS) -o $(TEST_TARGET) $(TEST_OBJ_FILES) $(GTEST_LIB) -pthread

# Compile source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Compile test files
$(BUILD_DIR)/%.o: $(TEST_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Run cppcheck for static analysis
cppcheck:
	$(CPP_CHECK) --enable=all --inconclusive --std=c99 $(SRC_DIR) $(TEST_DIR)

# Run tests
test: $(TEST_TARGET)
	$(TEST_TARGET)

# Clean build files
clean:
	rm -rf $(BUILD_DIR)/*

# Phony targets
.PHONY: clean cppcheck test
