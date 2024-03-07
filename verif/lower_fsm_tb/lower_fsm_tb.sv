`include "clocking.svh"
module receive_fsm_tb;

    `define ENABLE_DUMPFILE
    `include "tb_ess.svh"

    `CREATE_CLK(clk,  5ns,  5ns)

    logic reset;
    logic rd_data_valid_i;
    logic [3:0] rd_data_i;
    logic [3:0] op_a;
    logic [3:0] op_b;
    logic [7:0] op_c;
    logic [3:0] op_op;
    logic op_valid_o;

    // Instantiate the Unit Under Test (UUT)
    receive_fsm uut (
        .clk(clk),
        .reset(reset),
        .rd_data_valid_i(rd_data_valid_i),
        .rd_data_i(rd_data_i),
        .op_a(op_a),
        .op_b(op_b),
        .op_c(op_c),
        .op_op(op_op),
        .op_valid_o(op_valid_o)
    );


    // Initial values
    initial begin
        start_clk();

        reset = 0;
        rd_data_valid_i = 0;
        #10;
        reset = 1;
        #20; 
        rd_data_valid_i = 1;
        rd_data_i = 4'b1100;
        #10;
        rd_data_i = 4'b1010;
        #10;
        rd_data_i = 4'b1111;
        #10;
        rd_data_i = 4'b0010;
        #10;
        rd_data_i = 4'b1000;
        #10;
        rd_data_i = 4'b0111;
        #10;
        rd_data_i = 4'b1010;
        #10;
        rd_data_i = 4'b1000;
        #10;
        rd_data_i = 4'b1010;
        #10;
        rd_data_i = 4'b1111;
        #10;
        rd_data_i = 4'b0010;
        #10;
        rd_data_i = 4'b0110;
        #10;
        rd_data_i = 4'b1110;
        #10;
        rd_data_i = 4'b0010;        
        #10;
        rd_data_i = 4'b1110;

    end


endmodule