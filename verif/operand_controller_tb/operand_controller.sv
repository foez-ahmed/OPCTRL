// Description
// ### Author : Md NAzmus Sakib (email)


`include "config_pkg.sv"
  import config_pkg::uinstr_t;
  import config_pkg::addr_t;
  import config_pkg::data_t;
  import config_pkg::w_data_t;
  import config_pkg::code_t;

  module operand_controller(
    input logic clk_i,
    input logic arst_ni,
    input uinstr_t uinstr_i,
    input logic uinstr_valid_i,
    input logic rd_addr_ready_i,
    input data_t rd_data_i,
    input logic rd_data_valid_i,
    output logic uinstr_ready_o,
    output addr_t rd_addr_o,
    output logic rd_addr_valid_o,
    output data_t operand_a_o,
    output data_t operand_b_o,
    output w_data_t operand_c_o,
    output code_t operation_code_o,
    output logic operation_valid_o
  );


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic fifo_opcode_valid_i;
  logic fifo_opcode_ready_o;
  code_t fifo_data_in;
  logic fifo_val;
  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //assign fifo_uinstr_ready_i = addr_fsm_ready_o && fifo_opcode_ready_o;
  //assign addr_fsm_valid_i = fifo_uinstr_valid_o && fifo_opcode_ready_o;
  //assign fifo_opcode_valid_i = fifo_uinstr_valid_o  && addr_fsm_ready_o;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////




  addr_fsm addr_fsm_inst (
             .clk_i(clk_i),
             .arst_ni(arst_ni),
             .uinstr_i(uinstr_i),
             .uinstr_valid_i(uinstr_valid_i),
             .rd_addr_ready_i(rd_addr_ready_i),
             .fifo_opcode_ready_o(fifo_opcode_ready_o),
             .uinstr_ready_o(uinstr_ready_o),
             .rd_addr_valid_o(rd_addr_valid_o),
             .rd_addr_o(rd_addr_o),
             .fifo_data_in(fifo_data_in),
             .fifo_opcode_valid_in(fifo_opcode_valid_in)
           );

  fifo #(
         .PIPELINED(0),
         .ELEM_WIDTH($bits(operation_code_o)),
         .FIFO_SIZE(2)
       ) fifo_opcode(
         .clk_i(clk_i),
         .arst_ni(arst_ni),
         .elem_in_i(fifo_data_in),
         .elem_in_valid_i(fifo_opcode_valid_in),
         .elem_in_ready_o(fifo_opcode_ready_o),
         .elem_out_o(operation_code_o),
         .elem_out_valid_o(fifo_val),
         .elem_out_ready_i(operation_valid_o)
       );

  receive_fsm receive_fsm_inst (
                .clk(clk_i),
                .arst_ni(arst_ni),
                .rd_data_valid_i(rd_data_valid_i),
                .rd_data_i(rd_data_i),
                .operand_a_o(operand_a_o),
                .operand_b_o(operand_b_o),
                .operand_c_o(operand_c_o),
                .operation_valid_o(operation_valid_o)
              );



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////


  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS{{{
  /////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
