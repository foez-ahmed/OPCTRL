`include "clocking.svh"
module address_fsm_tb;

    `define ENABLE_DUMPFILE
    `include "tb_ess.svh"

    `CREATE_CLK(clk_i,  5ns,  5ns)

    logic arst_ni;
    logic data_i_valid_i;
    logic rec_ready_i;
    logic [15:0] data_i;
    logic fsm_ready_o;
    logic data_o_valid_o;
    logic [3:0] data_o;

    // Instantiate the address_fsm module
    address_fsm uut (
        .clk_i(clk_i),
        .arst_ni(arst_ni),
        .data_i_valid_i(data_i_valid_i),
        .rec_ready_i(rec_ready_i),
        .data_i(data_i),
        .fsm_ready_o(fsm_ready_o),
        .data_o_valid_o(data_o_valid_o),
        .data_o(data_o)
    );


    // Initial values
    initial begin
        start_clk_i();

        arst_ni = 0;
        data_i_valid_i = 0;
        rec_ready_i = 0;
        data_i = 16'b0;

        #10;
        arst_ni = 1;
        rec_ready_i = 1;
        #20;
        data_i_valid_i = 1;
        data_i = 16'hABCD;
        #10;
        data_i = 16'hCAFE;
        #10;
        data_i = 16'hDEAD;
    end

endmodule
