# Variables
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -Iinclude -std=c11
CXXFLAGS = -Wall -Wextra -Iinclude -std=c++17
LDFLAGS = -lpthread
SRCDIR = src
INCLUDEDIR = include
TESTDIR = test  # Directory for the test files
OBJDIR = build
BINDIR = bin
CPPCHECK_FLAGS = --enable=all --inconclusive --std=c11 --language=c --template=gcc

SRC = $(wildcard $(SRCDIR)/*.c)
OBJ = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRC))
TEST_SRC = $(wildcard $(TESTDIR)/*.cpp)
TEST_OBJ = $(patsubst $(TESTDIR)/%.cpp,$(OBJDIR)/%.o,$(TEST_SRC))
EXEC = $(BINDIR)/app
TEST_EXEC = $(BINDIR)/tests  # Name of the test executable
GTEST_XML_OUTPUT = tests/test_results.xml  # Path for the test result XML

# Targets
all: $(EXEC)

$(EXEC): $(OBJ)
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

test: $(TEST_EXEC)
	./$(TEST_EXEC) --gtest_output=xml:$(GTEST_XML_OUTPUT)  # Generate test result XML

$(TEST_EXEC): $(OBJ) $(TEST_OBJ)
	@mkdir -p $(BINDIR)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS) -lgtest -lgtest_main

$(OBJDIR)/%.o: $(TESTDIR)/%.cpp
	@mkdir -p $(OBJDIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

cppcheck:
	cppcheck $(CPPCHECK_FLAGS) $(SRCDIR) $(INCLUDEDIR)

lint: cppcheck  # Lint target to run cppcheck

clean:
	rm -rf $(OBJDIR) $(BINDIR)

.PHONY: all test cppcheck lint clean
