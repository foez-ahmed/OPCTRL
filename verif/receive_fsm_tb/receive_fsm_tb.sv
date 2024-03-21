`include "config_pkg.sv"
import config_pkg::uinstr_t;
import config_pkg::data_t;
import config_pkg::w_data_t;
import config_pkg::code_t;
module receive_fsm_tb;

`define ENABLE_DUMPFILE
`include "tb_ess.svh"
  // Declare signals
  logic clk, arst_ni, rd_data_valid_i, operation_valid_o;
  data_t rd_data_i;
  data_t operand_a_o, operand_b_o;
  w_data_t operand_c_o;
  
  // Instantiate receive_fsm module
  receive_fsm uut (
    .clk(clk),
    .arst_ni(arst_ni),
    .rd_data_valid_i(rd_data_valid_i),
    .rd_data_i(rd_data_i),
    .operand_a_o(operand_a_o),
    .operand_b_o(operand_b_o),
    .operand_c_o(operand_c_o),
    .operation_valid_o(operation_valid_o)
  );

  // Clock generationparity
  always #5 clk <= ~clk;

  // Reset generation
  initial begin
    arst_ni <= 1'b0;
    #20 arst_ni <= 1'b1;
  end

  // Stimulus process
  initial begin
    // Initialize inputs
    clk <= 1'b0;
    rd_data_valid_i <= 1'b0;
    rd_data_i <= 20'h0;

    // Wait for some time for reset to complete
    #40;

    @(posedge clk);
    rd_data_valid_i <= 1'b1;
    rd_data_i <= 20'hABCDE;
    @(posedge clk);
    rd_data_i <= 20'hDEADF;
    @(posedge clk);
    rd_data_i <= 20'hCAFEA;
    @(posedge clk);
    rd_data_i <= 20'hFADED;
    @(posedge clk);
    rd_data_i <= 20'hCBBDE;
    @(posedge clk);
    rd_data_i <= 20'hFBAAE;
    @(posedge clk);
    rd_data_i <= 20'hDEADF;
    @(posedge clk);
    rd_data_i <= 20'hCAFEA;
    @(posedge clk);
    rd_data_i <= 20'hFADED;
    @(posedge clk);
    rd_data_i <= 20'hDEADF;
    @(posedge clk);
    rd_data_i <= 20'hCAFEA;
    @(posedge clk);
    rd_data_i <= 20'hFADED;


    #200;

    // End of simulation
    $finish;
  end
endmodule

/*
always_ff @(posedge clk)
begin
  if(en_a) reg_a <= rd_data_i;
  if(en_b) reg_b <= rd_data_i;
  if(en_c) reg_c <= rd_data_i;
end
*/