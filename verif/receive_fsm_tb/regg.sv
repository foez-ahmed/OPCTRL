`include "config_pkg.sv"
import config_pkg::data_t;
import config_pkg::w_data_t;
module regg (
    input logic clk,
    input logic enable,   
    input data_t data_in, 
    output data_t data_out 
);

always_ff @(posedge clk) begin
    if(enable)begin
      data_out<= data_in;
    end else begin
      data_out <= data_out;
    end
  end
endmodule