# Compiler settings
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g -std=c99
CXXFLAGS = -I./include -pthread

# Paths for Google Test
GTEST_DIR = /usr/local
GTEST_LIB = /opt/homebrew/Cellar/googletest/1.15.2/lib
GTEST_MAIN_LIB = $(GTEST_LIB)/libgtest_main.a
GTEST_INCLUDE = /opt/homebrew/Cellar/googletest/1.15.2/include

# Source and object files
SRC = src/main.c src/sensor.c src/utils.c src/processing.c
OBJ = $(SRC:src/%.c=build/src/%.o)
EXE = my_program

# Directories
BUILD_DIR = build/src

# Targets
all: $(EXE)

$(EXE): $(OBJ)
	$(CXX) $(OBJ) -o $(EXE) -L$(GTEST_LIB) -lgtest -lgtest_main -lpthread

$(BUILD_DIR)/%.o: src/%.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -I$(GTEST_INCLUDE) -c $< -o $@

# Running cppcheck for static analysis
cppcheck:
	cppcheck --enable=all --inconclusive --quiet src/

# Clean up build files
clean:
	rm -rf $(BUILD_DIR)/*.o $(EXE)

.PHONY: all clean cppcheck
