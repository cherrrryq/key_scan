`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: cherrrryq
// 
// Create Date: 2017/11/08 18:56:21
// Design Name: 
// Module Name: key
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module key(
       input                clk,
       input                rst_n,
       input         [1:0]  key_data,
       output  reg          key_flag,
       output  reg   [1:0]  key_value
);

reg [1:0]    key_data_r;

always@(posedge clk)   begin
if(rst_n)   key_data_r <= 2'b0; 
else  key_data_r <=  key_data ;  end

reg  [19:0] delay_cnt;
always@(posedge clk) begin
if(rst_n)  delay_cnt <= 0;
else  begin if((delay_cnt == key_data_r) && ( key_data   !=   2'b11))  begin
            if ( delay_cnt < 20'd1000000 )
                delay_cnt  <=  delay_cnt  + 1'b1;
             else  delay_cnt  <= 20'd1000000;   end
             else   delay_cnt <= 0 ;  end
end
 
wire  key_trigger  = (  delay_cnt  == 20'd999999)  ? 1'b1 :  1'b0;

always@(posedge clk) begin
if(rst_n)   key_value  <=  2'b0;             
else if(key_trigger)   key_value <=  ~key_data_r ; 
else  key_value <= key_value;  end


always@(posedge clk)
begin if(rst_n)   key_flag <= 0;
      else  key_flag   <= key_trigger;  end
endmodule
