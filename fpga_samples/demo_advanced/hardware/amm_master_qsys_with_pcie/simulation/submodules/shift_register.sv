// shift_register file 
// Image Edge Detection FPGA project
// ECE337
// Coder: Aiman

module shift_register (
  output [7:0] out0, out1, out2, out3, out4, out5, out6, out7, out8,
  input [7:0] pix_in,
  input shift_enable,
  input n_rst, clear, clk
  );
  
reg [7:0] pix0, pix1, pix2, pix3, pix4, pix5, pix6, pix7, pix8;

assign  out0 = pix0;
assign  out1 = pix1;
assign  out2 = pix2;
assign  out3 = pix3;
assign  out4 = pix4;
assign  out5 = pix5;
assign  out6 = pix6;
assign  out7 = pix7;
assign  out8 = pix8;




always_ff @ (posedge clk, negedge n_rst) begin : SR
  if(n_rst == 1'b0) begin
    pix0 <= '0;
    pix1 <= '0;
    pix2 <= '0;
    pix3 <= '0;
    pix4 <= '0;
    pix5 <= '0;
    pix6 <= '0;
    pix7 <= '0;
    pix8 <= '0;
  end
  else if(shift_enable == 1 && clear == 0) begin
    pix0 <= pix_in;
    pix1 <= pix0;
    pix2 <= pix1;
    pix3 <= pix2;
    pix4 <= pix3;
    pix5 <= pix4;
    pix6 <= pix5;
    pix7 <= pix6;
    pix8 <= pix7;
  end
  else if(shift_enable == 0 && clear == 0) begin
    pix0 <= pix0;
    pix1 <= pix1;
    pix2 <= pix2;
    pix3 <= pix3;
    pix4 <= pix4;
    pix5 <= pix5;
    pix6 <= pix6;
    pix7 <= pix7;
    pix8 <= pix8;
  end
  else if(clear == 1) begin
    pix0 <= '0;
    pix1 <= '0;
    pix2 <= '0;
    pix3 <= '0;
    pix4 <= '0;
    pix5 <= '0;
    pix6 <= '0;
    pix7 <= '0;
    pix8 <= '0;
  end
end
 
endmodule
  


