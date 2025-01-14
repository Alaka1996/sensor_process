# Compiler and Flags
CXX = g++
CXXFLAGS = -Wall -std=c++17 -I$(PWD)/external/googletest/googletest/include
LDFLAGS = -lgtest -lgtest_main -pthread

# Directories
BUILD_DIR = build
GTEST_DIR = external/googletest
GTEST_BUILD_DIR = $(GTEST_DIR)/build

# Source and Object Files
SRC = src/main.cpp src/sensor.cpp
OBJ = $(SRC:.cpp=.o)

# Test Files and Targets
TEST_SRC = test/sensor_test.cpp
TEST_OBJ = $(TEST_SRC:.cpp=.o)
TEST_TARGET = test_program

# Targets
all: $(OBJ)
	$(CXX) -o main $(OBJ)

# Build Google Test from submodule (if not already built)
$(GTEST_BUILD_DIR)/lib/libgtest.a:
	mkdir -p $(GTEST_BUILD_DIR)
	cd $(GTEST_DIR) && cmake . && make

# Build and link test program with Google Test
test: $(OBJ) $(TEST_OBJ) $(GTEST_BUILD_DIR)/lib/libgtest.a
	$(CXX) -o $(TEST_TARGET) $(TEST_OBJ) $(OBJ) $(LDFLAGS)
	./$(TEST_TARGET)

# Run static analysis using Cppcheck
cppcheck: 
	@echo "Running Cppcheck..."
	@cppcheck --enable=all --inconclusive --quiet src/ test/ $(GTEST_DIR) 

# Compilation rules
%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@

# Clean
clean:
	rm -f $(OBJ) $(TEST_OBJ) $(TEST_TARGET) main
	rm -rf $(GTEST_BUILD_DIR)

# Run tests (optional)
run_tests: test
	./$(TEST_TARGET)
