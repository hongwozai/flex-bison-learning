TARGET=wc
OBJFILES=wc.o

all: $(TARGET)
	./$(TARGET) test.txt

%.c: %.l
	flex -o $@ $^

%.o: %.c
	gcc -c -o $@ $^

$(TARGET): $(OBJFILES)
	gcc -o $@ $^