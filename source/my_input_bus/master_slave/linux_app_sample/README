*************************************************************************	
 README to install the driver for the FPGA on the Atom
and run software which use the Atom-FPGA link			
*************************************************************************

How to install the drivers ?
1. Copy the linux_app_sample folder to the Atom on board the DE2i-150 board.
1. Go to drivers/
2. run load_terasic_qsys_pcie_driver.sh 

Ensure that the FPGA has the intended design with the PCIe modules integrated.
For incremental testing of the FPGA design make sure you reboot the Atom
first. 

How to access the FPGA in my C code ? 

1. An example c source file (app.c) has been provided for you which
demonstrates the usage of the Atom-FPGA link. You can read and write from the
16 32bit reconfigurable registers or to any location on the SDRAM. The
complete address space has been explained in the "Qsys Design and Atom coding
for PCIe Designs" document.

2. A minimal infrastructure using make is provided as well to compile your
design. You may use this as a baseline to create your own source code.


In case of any questions/bugs please feel free to email biswas6@purdue.edu
