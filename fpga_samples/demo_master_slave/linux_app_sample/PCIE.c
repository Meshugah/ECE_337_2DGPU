
#include <stdio.h>
#include <string.h>
#include "PCIE.h"

#if defined(__GNUC__)
    #include <dlfcn.h> // dlopen/dlclsoe for linxu
#else
    #define dlopen(x,y) ::LoadLibrary(x)
    #define dlclose     ::FreeLibrary
    #define dlsym       ::GetProcAddress
    #define dlerror()   "LoadLibrary failed"
#endif //


LPPCIE_Open 		PCIE_Open;
LPPCIE_Close 		PCIE_Close;
LPPCIE_Read32 		PCIE_Read32;
LPPCIE_Write32 		PCIE_Write32;
LPPCIE_Read16 		PCIE_Read16;
LPPCIE_Write16 		PCIE_Write16;
LPPCIE_Read8 		PCIE_Read8;
LPPCIE_Write8	 	PCIE_Write8;
LPPCIE_DmaWrite		PCIE_DmaWrite;
LPPCIE_DmaRead		PCIE_DmaRead;
LPPCIE_DmaFifoWrite	PCIE_DmaFifoWrite;
LPPCIE_DmaFifoRead	PCIE_DmaFifoRead;


void QueryModualName(char szName[]){
#if defined(__GNUC__)
    strcpy(szName, "./terasic_pcie_qsys.so");
#else
    // windows
	//check OS
	BOOL bIsWow64 = FALSE;
	typedef BOOL (WINAPI *LPFN_ISWOW64PROCESS) (HANDLE, PBOOL);
	LPFN_ISWOW64PROCESS fnIsWow64Process;

	fnIsWow64Process = (LPFN_ISWOW64PROCESS)GetProcAddress( GetModuleHandle("kernel32"),"IsWow64Process");
	if (NULL != fnIsWow64Process)
	{
		fnIsWow64Process(GetCurrentProcess(),&bIsWow64);
	}

	if(bIsWow64)
	{
        strcpy(szName, "TERASIC_PCIE_QSYSx64.DLL");
	}
	else
	{
        strcpy(szName, "TERASIC_PCIE_QSYS.DLL");
	}

#endif
}

	
void *PCIE_Load(void){

	BOOL bSuccess = TRUE;
	void *lib_handle;
    char szName[256];

    QueryModualName(szName);

	lib_handle = dlopen(szName, RTLD_NOW);
	if (!lib_handle){
		printf("Load %s error: %s\r\n", szName, dlerror());
		bSuccess = FALSE;
	}

	if(bSuccess){
		PCIE_Open = dlsym(lib_handle, "PCIE_Open");
		PCIE_Close = dlsym(lib_handle, "PCIE_Close");
		PCIE_Read32 = dlsym(lib_handle, "PCIE_Read32");
		PCIE_Write32 = dlsym(lib_handle, "PCIE_Write32");
		PCIE_Read16 = dlsym(lib_handle, "PCIE_Read16");
		PCIE_Write16 = dlsym(lib_handle, "PCIE_Write16");
		PCIE_Read8 = dlsym(lib_handle, "PCIE_Read8");
		PCIE_Write8 = dlsym(lib_handle, "PCIE_Write8");
		PCIE_DmaWrite = dlsym(lib_handle, "PCIE_DmaWrite");
		PCIE_DmaRead = dlsym(lib_handle, "PCIE_DmaRead");
		PCIE_DmaFifoWrite = dlsym(lib_handle, "PCIE_DmaFifoWrite");
		PCIE_DmaFifoRead = dlsym(lib_handle, "PCIE_DmaFifoRead");
		if (!PCIE_Open || !PCIE_Close ||
		    !PCIE_Read32 || !PCIE_Write32 ||
		    !PCIE_Read16 || !PCIE_Write16 ||
		    !PCIE_Read8 || !PCIE_Write8 ||
		    !PCIE_DmaWrite || !PCIE_DmaRead ||
		    !PCIE_DmaFifoWrite || !PCIE_DmaFifoRead
		)
			bSuccess = FALSE;
		
		
		if (!bSuccess){
			dlclose(lib_handle);
			lib_handle = 0;
		}
	}

	return lib_handle;
}

void PCIE_Unload(void *lib_handle){
	dlclose(lib_handle);
}


