CC = gcc
CFLAGS = -Iinclude -Wall -Wextra -std=c99
SRC = src/main.c src/sensor.c src/processing.c src/utils.c
OBJ = $(SRC:.c=.o)
TARGET = sensor_program

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
