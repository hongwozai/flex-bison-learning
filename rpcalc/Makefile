TARGET=rpcalc
OBJFILES=$(TARGET).yy.o $(TARGET).ll.o

all: $(TARGET)
	./$(TARGET) test.txt

%.yy.c: %.y
	bison -o $@ -d -y $^

%.ll.c: %.l
	flex -o $@ $^

%.o: %.c
	gcc -c -o $@ $^

$(TARGET): $(OBJFILES)
	gcc -o $@ $^