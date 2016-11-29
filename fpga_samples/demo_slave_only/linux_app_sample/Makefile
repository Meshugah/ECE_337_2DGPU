#
TARGET = app

#
CFLAGS = -g -Wall
LDFLAGS =  -g -Wall  
#LDFLAGS =  -g -Wall  -Iteraisc_pcie_qsys.so -ldl
#-ldl must be placed after the file calling lpxxxx funciton


build: $(TARGET)

app: app.o PCIE.o
	$(CC) $(LDFLAGS) $^ -o $@ -ldl

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~
