// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
/*

    v1.1.0, 11/28.2013
        -add api: PCIE_Read16, PCIE_Write16, PCIE_Read8, PCIE_Write8

*/

#ifndef _INC_TERASIC_PCIE_QSYS_H
#define _INC_TERASIC_PCIE_QSYS_H

/* GNU C/C++ Compiler */
#if defined(__GNUC__)
	#include <stdio.h>
	#define FAR
	#define PASCAL   
	#define __export 
	#define BOOL	int
	#define TRUE	1
	#define FALSE	0
	#define DWORD	unsigned int
	#define WORD	unsigned short
	#define USHORT	unsigned short
	#define UCHAR	unsigned char
	#define ULONG	unsigned int
    #define BYTE    unsigned char
	typedef int	PCIE_HANDLE;
#else
    // MS Windows
    #define NOMINMAX // avoid QT compile error
    #include <windows.h>
    typedef void *PCIE_HANDLE;
#endif



#ifdef __cplusplus
extern "C"{
#endif

#define PCIE_API FAR PASCAL
typedef DWORD PCIE_ADDRESS;
typedef DWORD PCIE_LOCAL_ADDRESS;
typedef DWORD PCIE_LOCAL_FIFO_ID;

#define DEFAULT_PCIE_VID 0x1172
#define DEFAULT_PCIE_DID 0xE001

typedef enum
{
    PCIE_BAR0 = 0,  // do not change it
    PCIE_BAR1,
    PCIE_BAR2,
    PCIE_BAR3,
    PCIE_BAR4,
    PCIE_BAR5
}PCIE_BAR;



typedef struct
{
    DWORD dwCounter;   // number of interrupts received
    DWORD dwLost;      // number of interrupts not yet dealt with
    BOOL fStopped;     // was interrupt disabled during wait
} PCIE_INT_RESULT;

//================================================================================
// PCI Bus Function
#pragma pack(push, 1)
typedef struct {
    USHORT  VendorID;                   // (ro)
    USHORT  DeviceID;                   // (ro)
    USHORT  Command;                    // Device control
    USHORT  Status;
    UCHAR   RevisionID;                 // (ro)
    UCHAR   ProgIf;                     // (ro)
    UCHAR   SubClass;                   // (ro)
    UCHAR   BaseClass;                  // (ro)
    UCHAR   CacheLineSize;              // (ro+)
    UCHAR   LatencyTimer;               // (ro+)
    UCHAR   HeaderType;                 // (ro)
    UCHAR   BIST;                       // Built in self test

    union {
        struct _MYPCI_HEADER_TYPE_0 {
            ULONG   BaseAddresses[6];
            ULONG   CIS;
            USHORT  SubVendorID;
            USHORT  SubSystemID;
            ULONG   ROMBaseAddress;
            UCHAR   CapabilitiesPtr;
            UCHAR   Reserved1[3];
            ULONG   Reserved2;
            UCHAR   InterruptLine;      //
            UCHAR   InterruptPin;       // (ro)
            UCHAR   MinimumGrant;       // (ro)
            UCHAR   MaximumLatency;     // (ro)
        } type0;


    } u;
    UCHAR   DeviceSpecific[192];
} PCIE_CONFIG;

#pragma pack(pop)


typedef void (PCIE_API *TERASIC_INT_HANDLER)( PCIE_HANDLE hALTERA, PCIE_INT_RESULT *intResult);


//================================================================================
// function prototype used for "static load DLL"
#if 0
BOOL  PCIE_API PCIE_ScanCard(WORD wVendorID, WORD wDeviceID, DWORD *pdwDeviceNum, PCIE_CONFIG szConfigList[]); // PciVID/PciPID=0/0--> scan all pci card
PCIE_HANDLE PCIE_API PCIE_Open(WORD wVendorID, WORD wDeviceID, WORD wCardNum);
void PCIE_API PCIE_Close(PCIE_HANDLE hFPGA);
BOOL PCIE_API PCIE_Read32 (PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, DWORD *pdwData);
BOOL PCIE_API PCIE_Write32 (PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, DWORD dwData);
BOOL PCIE_API PCIE_Read16 (PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, WORD *pwData);
BOOL PCIE_API PCIE_Write16 (PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, WORD wData);
BOOL PCIE_API PCIE_Read8 (PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, BYTE *pcData);
BOOL PCIE_API PCIE_Write8 (PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, BYTE cData);
BOOL PCIE_API PCIE_DmaRead (PCIE_HANDLE hFPGA, PCIE_LOCAL_ADDRESS LocalAddress, void *pBuffer, DWORD dwBufSize);
BOOL PCIE_API PCIE_DmaWrite (PCIE_HANDLE hFPGA, PCIE_LOCAL_ADDRESS LocalAddress, void *pData, DWORD dwDataSize);
BOOL PCIE_API PCIE_DmaFifoRead (PCIE_HANDLE hFPGA, PCIE_LOCAL_FIFO_ID LocalFifoId, void *pBuffer, DWORD dwBufSize);
BOOL PCIE_API PCIE_DmaFifoWrite (PCIE_HANDLE hFPGA, PCIE_LOCAL_FIFO_ID LocalFifoId, void *pData, DWORD dwDataSize);
// interrupt
BOOL PCIE_API PCIE_IntIsEnabled (PCIE_HANDLE hFPGA);
BOOL PCIE_API PCIE_IntEnable (PCIE_HANDLE hFPGA, TERASIC_INT_HANDLER funcIntHandler);
void PCIE_API PCIE_IntDisable (PCIE_HANDLE hFPGA);
#endif
//================================================================================
// function prototype used for "dynamic load DLL"
typedef BOOL  (PCIE_API *LPPCIE_ScanCard)(WORD wVendorID, WORD wDeviceID, DWORD *pdwDeviceNum, PCIE_CONFIG szConfigList[]);
typedef PCIE_HANDLE (PCIE_API *LPPCIE_Open)(WORD wVendorID, WORD wDeviceID, WORD wCardNum);
typedef void (PCIE_API *LPPCIE_Close)(PCIE_HANDLE hFPGA);
typedef BOOL (PCIE_API *LPPCIE_Read32)(PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, DWORD *pdwData);
typedef BOOL (PCIE_API *LPPCIE_Write32)(PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, DWORD dwData);
typedef BOOL (PCIE_API *LPPCIE_Read16)(PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, WORD *pwData);
typedef BOOL (PCIE_API *LPPCIE_Write16)(PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, WORD wData);
typedef BOOL (PCIE_API *LPPCIE_Read8)(PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, BYTE *pcData);
typedef BOOL (PCIE_API *LPPCIE_Write8)(PCIE_HANDLE hFPGA, PCIE_BAR PciBar, PCIE_ADDRESS PciAddress, BYTE cData);
typedef BOOL (PCIE_API *LPPCIE_DmaRead) (PCIE_HANDLE hFPGA, PCIE_LOCAL_ADDRESS LocalAddress, void *pBuffer, DWORD dwBufSize);
typedef BOOL (PCIE_API *LPPCIE_DmaWrite) (PCIE_HANDLE hFPGA, PCIE_LOCAL_ADDRESS LocalAddress, void *pData, DWORD dwDataSize);
typedef BOOL (PCIE_API *LPPCIE_DmaFifoRead) (PCIE_HANDLE hFPGA, PCIE_LOCAL_FIFO_ID LocalFifoId, void *pBuffer, DWORD dwBufSize);
typedef BOOL (PCIE_API *LPPCIE_DmaFifoWrite) (PCIE_HANDLE hFPGA, PCIE_LOCAL_FIFO_ID LocalFifoId, void *pData, DWORD dwDataSize);
// interrupt
typedef BOOL (PCIE_API *LPPCIE_IntIsEnabled) (PCIE_HANDLE hFPGA);
typedef BOOL (PCIE_API *LPPCIE_IntEnable) (PCIE_HANDLE hFPGA, TERASIC_INT_HANDLER funcIntHandler);
typedef void (PCIE_API *LPPCIE_IntDisable) (PCIE_HANDLE hFPGA);





#ifdef __cplusplus
}
#endif



#endif /* _INC_TERASIC_PCIE_H */

