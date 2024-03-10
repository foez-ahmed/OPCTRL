// Description
// ### Author : Md Nazmus Sakib(email)

`include "config_pkg.sv"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"
import config_pkg::uinstr_t;
import config_pkg::addr_t;
import config_pkg::code_t;

module addr_fsm(
    input logic clk_i,
    input logic arst_ni,
    input logic uinstr_valid_i,
    input logic rd_addr_ready_i,
    input uinstr_t uinstr_i,
    input logic fifo_opcode_ready_o,
    output logic uinstr_ready_o,
    output logic rd_addr_valid_o,
    output addr_t rd_addr_o,
    output code_t fifo_data_in,
    output logic fifo_opcode_valid_in
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
  always_ff @(posedge clk_i)
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
    rd_addr_o=0;
    rd_addr_valid_o=0;
    uinstr_ready_o = 1;
    fifo_data_in = 0;
    fifo_opcode_valid_in=0;

    case (currentstate)
      vrs1:
      begin
        if(uinstr_valid_i && rd_addr_ready_i)
        begin
          rd_addr_o = uinstr_i.vrs1;
          rd_addr_valid_o =1;
          uinstr_ready_o =0;
          fifo_opcode_valid_in=0;
          nextstate = vrs2;
        end
        else
        begin
          nextstate = vrs1;
        end
      end
      vrs2:
      begin
        if(rd_addr_ready_i)
        begin
          rd_addr_o = uinstr_i.vrs2;
          nextstate = vrs3;
        end
        else
        begin
          nextstate = vrs2;
        end
      end
      vrs3:
      begin
        if(rd_addr_ready_i)
        begin
          rd_addr_o = uinstr_i.vrs3;
          nextstate = vrs4;
        end
        else
        begin
          nextstate = vrs3;
        end
      end
      vrs4:
      begin
        if(rd_addr_ready_i)
        begin
          rd_addr_o = uinstr_i.vrs3 +1;
          rd_addr_valid_o = 0;
          uinstr_ready_o = 1;
          nextstate = vrs1;
          if(fifo_opcode_ready_o) begin
          fifo_data_in = uinstr_i.opcode;
          fifo_opcode_valid_in=1;
          end           
        end
        else
        begin
          nextstate = vrs4;
        end
      end
    endcase
  end
  //}}}
endmodule
