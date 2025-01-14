# Compiler and flags
CC = gcc
CFLAGS = -Iinclude -Wall -Wextra -std=c99

# Source files and object files
SRC = src/main.c src/sensor.c src/processing.c src/utils.c
OBJ = $(SRC:.c=.o)
TARGET = sensor_program

# Default target
all: $(TARGET)

# Build the program
$(TARGET): $(OBJ)
	$(CC) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Run cppcheck for static code analysis
cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC)

# Clean up build files
clean:
	rm -f $(OBJ) $(TARGET)
