module regg (
    input logic clk,
    input logic enable,   
    input logic data_in, 
    output logic data_out 
);

always_ff @(posedge clk) begin
    if(enable)begin
      data_out<= data_in;
    end
endmodule