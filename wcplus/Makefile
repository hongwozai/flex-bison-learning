TARGET=wc
OBJFILES=wc.o

all: $(TARGET)
	./$(TARGET) test.txt

%.cc: %.l
	flex -o $@ $^

%.o: %.cc
	g++ -c -o $@ $^

$(TARGET): $(OBJFILES)
	g++ -o $@ $^