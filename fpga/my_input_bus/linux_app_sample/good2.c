#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>

#include "PCIE.h"

//MAX BUFFER FOR DMA
#define MAXDMA 16

//BASE ADDRESS FOR CONTROL REGISTER
#define CRA 0x00000000		// This is the starting address of the Custom Slave module. This maps to the address space of the custom module in the Qsys subsystem.
#define BIT2 0x00000080
#define BIT3 0x00000100

//BASE ADDRESS TO SDRAM
#define SDRAM 0x08000000	// This is the starting address of the SDRAM controller. This maps to the address space of the SDRAM controller in the Qsys subsystem.
#define START_BYTE 0xF00BF00B
#define STOP_BYTE 0xDEADF00B
#define RWSIZE (32 /8)
#define OUTSIZE 96

PCIE_BAR pcie_bars[] = { PCIE_BAR0, PCIE_BAR1 , PCIE_BAR2 , PCIE_BAR3 , PCIE_BAR4 , PCIE_BAR5 };

void opcodeIn( PCIE_HANDLE hPCIe, DWORD, int  );
void checkOpcode( PCIE_HANDLE hPCIE, DWORD addr );
void testDMA( PCIE_HANDLE hPCIe, DWORD addr);

int main(void)
{
	
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

	//input opcodes
	int bitNum = 1;
	opcodeIn(hPCIe, CRA, bitNum);			

	bitNum += 32;
	opcodeIn(hPCIe, CRA, bitNum);        
	
	bitNum += 32;
	opcodeIn(hPCIe, CRA, bitNum);

	//check values
	checkOpcode(hPCIe, CRA);
	

	return 0;
}

//Tests 96 bit consecutive PCIE_Write32 to address
void opcodeIn( PCIE_HANDLE hPCIe, DWORD addr, int bitNum )
{
	BOOL bPass;
	DWORD testVal = 0x0;
	

	WORD i = 0;
	for (i = 0; i < 32 ; i++ )
	{
		bPass = PCIE_Write32( hPCIe, pcie_bars[0], addr, testVal);
		if (!bPass)
		{
			printf("test FAILED: write did not return success");
			return;
		}
		printf("\nWrote bit %d of opcode, value is: %d",bitNum, testVal); 		
		testVal = testVal + 1;
		addr = addr + 4;
		bitNum = bitNum + 1;
	}
	return;
}


void checkOpcode( PCIE_HANDLE hPCIe, DWORD addr )
{
		
	BOOL bPass;
	DWORD readval;
	int outarray[OUTSIZE];	 

	WORD i = 0;
	for (i = 0; i < 32; i++)
	{
		bPass = PCIE_Read32( hPCIe, pcie_bars[0], addr, &readval);
		if(!bPass)
		{
			printf("\nfail");
			return;
		}
		printf("\nreading bit %d of opcode, value is : %d",i, readval);
		addr = addr + 4;
		outarray[i] = readval;		
	}
	return;
}






//tests DMA write of buffer to address
void testDMA( PCIE_HANDLE hPCIe, DWORD addr)
{
	BOOL bPass;
	DWORD testArray[MAXDMA];
	DWORD readArray[MAXDMA];
	
	WORD i = 1;
	testArray[0] = START_BYTE;
	while ( i < MAXDMA )
	{
		testArray[i] = i  + 0x0f;
		i++;
	}

	//bPass = PCIE_DmaWrite(hPCIe, addr, testArray, MAXDMA * RWSIZE );
	//if (!bPass)
	//{
	//	printf("test FAILED: write did not return success");
	//	return;
	//}
	bPass = PCIE_DmaRead(hPCIe, addr, readArray, MAXDMA * RWSIZE );
	if (!bPass)
	{
		printf("test FAILED: read did not return success");
		return;
	}
	i = 0;
	while ( i < MAXDMA )
	{
		printf("Testing SDRAM at addr %x: ", addr);
		if (testArray[i] == readArray[i])
		{
			printf("Test PASSED: expected %x, received %x\n", testArray[i], readArray[i]);
		}
		else
		{
			printf("Test FAILED: expected %x, received %x\n", testArray[i], readArray[i]);
		}
		i++;
		addr = addr + 4;
	}
	return;
}
