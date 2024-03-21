// Description
// ### Author : Md Nazmus Sakib(email)

`include "config_pkg.sv"


module address_fsm
import config_pkg::uinstr_t;
import config_pkg::addr_t;
import config_pkg::code_t;
(
    input logic clk_i,
    input logic arst_ni,
    input uinstr_t uinstr_i ='0,
    input logic uinstr_valid_i ='0,
    output logic uinstr_ready_o,
    output addr_t rd_addr_o,
    output logic rd_addr_valid_o,
    input logic  rd_addr_ready_i
    //input logic fifo_opcode_ready_o,
    //output code_t fifo_data_in,
    //output logic fifo_opcode_valid_in
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum logic [1:0] {vrs1,vrs2,vrs3,vrs4} State;
  State currentstate, nextstate;
  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////
  uinstr_t uinstr_reg;
  logic [1:0] en;
  logic start;
  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////




  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////
  always_ff @(posedge clk_i or negedge arst_ni)
  begin
    if(~arst_ni)
    begin
      currentstate <= vrs1;
    end
    else
    begin
      currentstate <= nextstate;
    end
  end
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-Combinational{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //State Assignment


  always_comb
  begin
    //uinstr_ready_o = 1;
    //fifo_data_in = 0;
    //fifo_opcode_valid_in=0;
    case (currentstate)
      vrs1:
      begin
        if(uinstr_valid_o && rd_addr_ready_i) begin
          en = 2'b00;
          uinstr_ready_o = 0;
          nextstate = vrs2;
        end else begin
          uinstr_ready_o = 1;
          nextstate = vrs1;
        end
      end
      vrs2:
      begin
        if(rd_addr_ready_i) begin
          en = 2'b01;
          uinstr_ready_o = 0;
          nextstate = vrs3;
        end else nextstate = vrs2;
      end
      vrs3:
      if(rd_addr_ready_i) begin
        en = 2'b10;
        uinstr_ready_o = 0;
        nextstate = vrs4;
      end else nextstate = vrs3;
      vrs4:
      if(rd_addr_ready_i) begin
        en = 2'b11;
        uinstr_ready_o = 1;
        nextstate = vrs1;
      end else nextstate = vrs4;
    endcase
  end

  always_comb begin
    //if (currentstate == vrs1 || currentstate == vrs2 || currentstate == vrs3) begin
    // uinstr_ready_o = 0;
    //end else begin
    //  uinstr_ready_o = 1;
    //end
    if(uinstr_valid_i && en == 2'b00) rd_addr_o = uinstr_reg.vrs1;
    if(uinstr_valid_i && en == 2'b01) rd_addr_o = uinstr_reg.vrs2;
    if(uinstr_valid_i && en == 2'b10) rd_addr_o = uinstr_reg.vrs3;
    if(uinstr_valid_i && en == 2'b11) rd_addr_o = uinstr_reg.vrs3 +1;

  end

  always_ff @(posedge clk_i) begin
    if (uinstr_valid_i) uinstr_reg <= uinstr_i;
    rd_addr_valid_o <= uinstr_valid_i;
  end
  //}}}
endmodule
