//This is the tb file of Top_module
//Getting Right Clock:Clock matching, using sel
//Dead time:
//delay
//Glitch Monitoring:
//Reset Activation:will follow pll1
//reset makes 0
//enable checking
// ### Author : Nazmus Sakib (nazmus.sakib.punno@dsinnovators.com)


`include "macros.svh"
`include "config_pkg.sv"
  import config_pkg::uinstr_t;
  import config_pkg::addr_t;
  import config_pkg::data_t;
  import config_pkg::w_data_t;
  import config_pkg::code_t;
module operand_controller_tb;

`define ENABLE_DUMPFILE
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-IMPORTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////


  // bring in the testbench essentials functions and macros
`include "tb_ess.svh"


  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////


  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////


  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////


  // generates static task start_clk_i with tHigh:4ns tLow:6ns
  `CREATE_CLK(clk_i,  5ns,  5ns)

  logic arst_ni=1;
  uinstr_t uinstr_i;
  logic uinstr_valid_i=0;
  logic rd_addr_ready_i = 1;
  data_t rd_data_i;
  logic rd_data_valid_i;
  logic uinstr_ready_o;
  addr_t rd_addr_o;
  logic rd_addr_valid_o;
  data_t operand_a_o;
  data_t operand_b_o;
  w_data_t operand_c_o;
  code_t operation_code_o;
  logic operation_valid_o;

  logic [3:0] addr_queue [$];
  logic [3:0] data_queue [$];
  logic [3:0] opcode_queue [$];
  addr_t check_addr;
  logic addr_mismatch;
  logic data_mismatch;
  logic opcode_mismatch;
  data_t check_op_a;
  data_t check_op_b;
  data_t check_op_c;
  code_t check_opcode;
  w_data_t check_op_c_2;


  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-VARIABLES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////






  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INTERFACES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////






  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-CLASSES{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////






  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign HSUINST = uinstr_valid_i &&  uinstr_ready_o;
  assign HSADDR = rd_addr_valid_o &&  rd_addr_ready_i;




  //}}}


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////
  operand_controller dut (
                       .clk_i(clk_i),
                       .arst_ni(arst_ni),
                       .uinstr_i(uinstr_i),
                       .uinstr_valid_i(uinstr_valid_i),
                       .rd_addr_ready_i(rd_addr_ready_i),
                       .rd_data_i(rd_data_i),
                       .rd_data_valid_i(rd_data_valid_i),
                       .uinstr_ready_o(uinstr_ready_o),
                       .rd_addr_o(rd_addr_o),
                       .rd_addr_valid_o(rd_addr_valid_o),
                       .operand_a_o(operand_a_o),
                       .operand_b_o(operand_b_o),
                       .operand_c_o(operand_c_o),
                       .operation_code_o(operation_code_o),
                       .operation_valid_o(operation_valid_o)
                     );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

task static apply_reset_and_uinstr_valid();
  fork

    begin
      #10ns;
      arst_ni <= 0;
      #10ns;
      arst_ni <= 1;
    end


    begin
      #50ns;
      uinstr_valid_i <= 1;
      #100ns;
      uinstr_valid_i <= 0;
    end
  join_none
endtask

task static gen_random_addr();
fork
    forever begin
        @(posedge clk_i);
        if(HSUINST) begin
            uinstr_i <= $urandom;
        end

    end
  join_none
endtask

task static gen_random_data();
fork
    forever begin
        @(posedge clk_i);
        if(rd_data_valid_i) begin
            rd_data_i <= $urandom;
        end
    end
  join_none
endtask

task static apply_rd_data_valid_i();
fork
    forever begin
        @(posedge clk_i);
        if(rd_addr_valid_o) begin
            rd_data_valid_i <= 1;
        end else rd_data_valid_i <= 0;
    end
  join_none
endtask


  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-PROCEDURALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

always_ff @(posedge clk_i) begin
    if (HSUINST) begin
        addr_queue <= {uinstr_i.vrs1, uinstr_i.vrs2, uinstr_i.vrs3, uinstr_i.vrs3 + 1};
        opcode_queue.push_back(uinstr_i.opcode);
    end
    
    if (rd_data_valid_i) begin
        data_queue.push_back(rd_data_i);
    end
end

always_ff @(posedge clk_i) begin
    if(HSADDR) begin
        check_addr <= addr_queue.pop_front();
        if(rd_addr_o != check_addr) begin
            $warning("address doesnt match"); 
            addr_mismatch <= 1;
        end else addr_mismatch <= 0;
    end
end

always_ff @(posedge clk_i) begin
    if(operation_valid_o) begin
        check_op_a <= data_queue.pop_front();
        check_op_b <= data_queue.pop_front();
        check_op_c <= data_queue.pop_front();
        check_op_c_2 <= {check_op_c, data_queue.pop_front()};
        check_opcode <= opcode_queue.pop_front();
        if(operand_a_o != check_op_a || operand_b_o != check_op_b || operand_c_o != check_op_c_2) begin
            $warning("data doesnt match");  
            data_mismatch <= 1;     
        end else begin
            data_mismatch <= 0;
        end

        if(operation_code_o != check_opcode ) begin
            $warning("opcode doesnt match"); 
            opcode_mismatch <= 1;
        end else opcode_mismatch <= 0;
    end
end


  initial
  begin  // main initial{{{

    start_clk_i();
    apply_reset_and_uinstr_valid();
    gen_random_addr();
    gen_random_data();
    apply_rd_data_valid_i();


    #1000ns;
    result_print(!data_mismatch,"data_check!!");
    result_print(!addr_mismatch,"addr_check!!");
    result_print(!opcode_mismatch,"opcode_check!!");

    $finish;

  end  //}}}
  //}}}
endmodule
