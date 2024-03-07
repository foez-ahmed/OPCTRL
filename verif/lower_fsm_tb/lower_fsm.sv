// Description
// ### Author : Md Nazmus Sakib(email)

`include "config_pkg.sv"

module receive_fsm (
    input logic clk,
    input logic arst_ni,
    input logic rd_data_valid_i,
    input data_t rd_data_i,
    output data_t operand_a_o,
    output data_t operand_b_o,
    output w_data_t operand_c_o,
    output code_t op_code_o,
    output uinstr_t uinstr_o,
    output logic op_valid_o
);

data_t reg_a;
data_t reg_b;
data_t reg_c;

typedef enum logic [1:0] {oper_a, oper_b, oper_c, oper_c_2} State;
State currentstate, nextstate;

always_ff @(posedge clk) begin
    if (~arst_ni) begin
        currentstate <= oper_a;
    end else begin
        currentstate <= nextstate;
    end
end

always_comb begin
    case (currentstate)
        oper_a: begin
            if (rd_data_valid_i) begin
                reg_a = rd_data_i;
                op_valid_o =0;
                nextstate = oper_b;
            end else
                nextstate = oper_a;
        end

        oper_b: begin
            if (rd_data_valid_i) begin
                reg_b = rd_data_i;
                nextstate = oper_c;
            end else
                nextstate = oper_b;
        end

        oper_c: begin
            if (rd_data_valid_i) begin
                reg_c = rd_data_i;
                nextstate = oper_c_2;
            end else
                nextstate = oper_c;
        end

        oper_c_2: begin
            if (rd_data_valid_i) begin
                operand_a_o = reg_a;
                operand_b_o = reg_b;
                operand_c_o = {reg_c, rd_data_i};
                op_code_o = uinstr_i.opcode;
                uinstr_o = uinstr_i;
                op_valid_o =1;
                nextstate = oper_a;
            end else
                nextstate = oper_c_2;
        end
    endcase
end
endmodule
