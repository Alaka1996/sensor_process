# Compiler and flags
CC = gcc
CXX = g++
CFLAGS = -Wall -std=c99
CXXFLAGS = -Wall -std=c++11

# Paths
GTEST_DIR = external/googletest
GTEST_LIB_DIR = $(GTEST_DIR)/lib

# Directories for object files and executable
OBJ_DIR = obj
BIN_DIR = bin

# Source files
SRC = src/main.c src/sensor.c src/utils.c
TEST_SRC = test/test_main.cpp test/test_utils.cpp

# Output files
EXEC = $(BIN_DIR)/my_program
TEST_EXEC = $(BIN_DIR)/run_tests

# Include paths
INCLUDE_DIRS = -I include -I $(GTEST_DIR)/googletest/include

# GoogleTest linking
GTEST_LIBS = -L$(GTEST_LIB_DIR) -lgtest -lgtest_main -pthread

# Make sure necessary directories exist
$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR))

# Build all
all: $(EXEC)

# Compile the main program
$(EXEC): $(OBJ_DIR)/main.o $(OBJ_DIR)/sensor.o $(OBJ_DIR)/utils.o
	$(CXX) -o $@ $^ $(GTEST_LIBS)

# Build test program
$(TEST_EXEC): $(OBJ_DIR)/test_main.o $(OBJ_DIR)/test_utils.o $(GTEST_LIBS)
	$(CXX) -o $@ $^ $(GTEST_LIBS)

# Compile source files
$(OBJ_DIR)/%.o: src/%.c
	$(CC) -c $(CFLAGS) $< -o $@

$(OBJ_DIR)/%.o: test/%.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDE_DIRS) $< -o $@

# Run tests
run_tests: $(TEST_EXEC)
	./$(TEST_EXEC)

# Static code analysis using cppcheck
cppcheck:
	cppcheck --enable=all --inconclusive --quiet --error-exitcode=1 $(SRC) $(TEST_SRC)

# Clean build files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean cppcheck run_tests
