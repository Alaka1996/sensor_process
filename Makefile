# Compiler settings
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g -std=c99
CXXFLAGS = -I/Users/alakanandabg/googletest/include -std=c++11 -pthread

# Paths for Google Test
GTEST_DIR = /usr/local
GTEST_LIB = /opt/homebrew/Cellar/googletest/1.15.2/lib
GTEST_MAIN_LIB = $(GTEST_DIR)/lib/libgtest_main.a
GTEST_INCLUDE = /opt/homebrew/Cellar/googletest/1.15.2/include

# Source and object files
SRC = src/main.c src/sensor.c
OBJ = $(SRC:.c=.o)
EXE = my_program

# Directories
BUILD_DIR = build

# Targets
all: $(EXE)

$(EXE): $(OBJ)
	$(CXX) $(OBJ) -o $(EXE) $(GTEST_LIB) $(GTEST_MAIN_LIB) -lpthread

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -I$(GTEST_INCLUDE) -c $(SRC) -o $(BUILD_DIR)/$@

# Running cppcheck for static analysis
cppcheck:
	cppcheck --enable=all --inconclusive --quiet src/

# Clean up build files
clean:
	rm -rf $(BUILD_DIR)/*.o $(EXE)

.PHONY: all clean cppcheck
