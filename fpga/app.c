#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <unistd.h>

#include "PCIE.h"


#define WIDTH 1
//MAX BUFFER FOR DMA
#define MAXDMA 50

//BASE ADDRESS FOR CONTROL REGISTER
#define CRA 0x00000000		// This is the starting address of the Custom Slave module. This maps to the address space of the custom module in the Qsys subsystem.

//BASE ADDRESS TO SDRAM
#define SDRAM 0x08000000	// This is the starting address of the SDRAM controller. This maps to the address space of the SDRAM controller in the Qsys subsystem.
#define START_BYTE 0xF00BF00B
#define RWSIZE (32 / 8)
PCIE_BAR pcie_bars[] = { PCIE_BAR0, PCIE_BAR1 , PCIE_BAR2 , PCIE_BAR3 , PCIE_BAR4 , PCIE_BAR5 };

void testDMA( PCIE_HANDLE hPCIe, DWORD addr, ssize_t, char*);

int main( int argc, char *argv[])
{
	//argument passing	
	if(argc != 2)
	{
		printf("\nplease include argument.txt argument\n");
		return 0;
	}
	
	//PCIE stuff
	void *lib_handle;
	PCIE_HANDLE hPCIe;

	lib_handle = PCIE_Load();		// Dynamically Load the PCIE library
	if (!lib_handle)
	{
		printf("PCIE_Load failed\n");
		return 0;
	}
	hPCIe = PCIE_Open(0,0,0);		// Every device is a like a file in UNIX. Opens the PCIE device for reading/writing

	if (!hPCIe)
	{
		printf("PCIE_Open failed\n");
		return 0;
	}


	//FILE IO
	//file IO	
	FILE * filepointer;
	char* input = argv[1];
	filepointer = fopen(input,"rb");
	char * line = NULL;
	size_t len = 0;
	ssize_t read;	

	while ((read = getline(&line, &len, filepointer)) != -1) {
		printf("Retrieved instructions of length %zu : \n", read -1);
		printf("%s",line);
		getchar();
		//WEVE got the line here, now operations
		
		//test SDRAM
		printf("\n************Testing the SDRAM for reads and writes through the DMA ************\n\n");
		testDMA(hPCIe,SDRAM, read -1, line);			// Test the SDRAM for reads and writes
		
	
		
		
		
		}

	
	
	
	//close file pointer
	fclose(filepointer);
	if (line)
		free(line);
	
	

	
	return 0;
}


//tests DMA write of buffer to addresses in the SDRAM 

void testDMA( PCIE_HANDLE hPCIe, DWORD addr,ssize_t len, char * address)
{
	BOOL bPass;
	int testArray[MAXDMA];
	int readArray[MAXDMA];
	
	int i = 0;
	
	//printf("\n\n%s\n\n",address);
	
	
	
	while ( i < len )
	{
		testArray[i] = address[i];
		i++;
	}

	bPass = PCIE_DmaWrite(hPCIe, addr, testArray, MAXDMA * RWSIZE );
	if (!bPass)
	{
		printf("test FAILED: write did not return success");
		return;
	}
	bPass = PCIE_DmaRead(hPCIe, addr, readArray, MAXDMA * RWSIZE );
	if (!bPass)
	{
		printf("test FAILED: read did not return success");
		return;
	}
	
	i = 0;
	while ( i < len )
	{
		if (testArray[i] == readArray[i])
		{
			printf("Test PASSED: address: %x expected %x, received %x\n",addr,  testArray[i] %10, readArray[i] %10);
		}
		else
		{
			printf("Test FAILED: expected %x, received %x\n", testArray[i], readArray[i]);
		}
		i++;
		addr++;
	}
	return;
}

