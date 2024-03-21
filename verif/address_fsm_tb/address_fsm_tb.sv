`include "config_pkg.sv"
import config_pkg::uinstr_t;
import config_pkg::addr_t;
import config_pkg::code_t;
module address_fsm_tb();
`define ENABLE_DUMPFILE
`include "tb_ess.svh"

    logic clk_i;
    logic arst_ni;
    logic uinstr_valid_i;
    logic rd_addr_ready_i;
    logic uinstr_ready_o;
    logic rd_addr_valid_o;
    uinstr_t uinstr_i;
    addr_t rd_addr_o;

    // Instantiate the addr_fsm module
    address_fsm dut (
        .clk_i(clk_i),
        .arst_ni(arst_ni),
        .uinstr_i(uinstr_i),
        .uinstr_valid_i(uinstr_valid_i),
        .uinstr_ready_o(uinstr_ready_o),
        .rd_addr_o(rd_addr_o),
        .rd_addr_valid_o(rd_addr_valid_o),
        .rd_addr_ready_i(rd_addr_ready_i)
    );

    task static start_clk_i();
        fork
            forever begin
                clk_i <= '1; #5ns;
                clk_i <= '0; #5ns;
            end
        join_none
    endtask

    task static apply_reset();
    arst_ni <= 1; #50ns;
    arst_ni <= 0; #50ns;
    arst_ni <= 1; #50ns;
    endtask

    task static gen_random_addr();
    fork
        forever begin
            @(posedge clk_i);
            if(uinstr_ready_o) begin
                uinstr_i <= $urandom;
                uinstr_valid_i<= 1;
            end
        end
      join_none
    endtask

    
    initial begin
        apply_reset();
        start_clk_i();
        gen_random_addr();
        rd_addr_ready_i = 1;
        #350;
        $finish;
    end

endmodule
