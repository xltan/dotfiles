CXX=g++
CXXFLAGS=-g -std=c++17 -Wall -pedantic
BIN=main

SRC=$(wildcard *.cc)
OBJ=$(SRC:%.cc=%.o)

all: $(OBJ)
	$(CXX) $(CXXFLAGS) -o $(BIN) $^
	./$(BIN)

%.o: %.cc
	$(CXX) $(CXXFLAGS) -o $@ -c $< -g

clean:
	rm -f *.o
	rm $(BIN)
