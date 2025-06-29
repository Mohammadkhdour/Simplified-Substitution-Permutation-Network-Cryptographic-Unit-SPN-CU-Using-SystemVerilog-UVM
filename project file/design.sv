`include "spn_package.sv"
module SPN_CU (
    input  logic          clk,
    input  logic          reset,
    input  logic [1:0]    opcode,     // Use enum type from package
    input  logic [15:0]   in_data,
    input  logic [31:0]   key,
    output logic [15:0]   out_data,
    output logic [1:0]    valid
);

    import spn_pkg::*;

    round_key_t round_key;
  
    logic [15:0] round0, round1, round2, round3;

    // Key schedule: synchronous reset (reset sensitive)
    always_ff @(posedge clk) begin
      if (reset) begin
            round_key[0] = 16'h0;
            round_key[1] = 16'h0;
            round_key[2] = 16'h0;
            round_key[3] = 16'h0;
        end else begin
            round_key[0] = {key[7:0],  key[23:16]};
            round_key[1] = key[15:0];
            round_key[2] = {key[7:0],  key[31:24]};
            round_key[3] = key[31:16]; 
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            out_data <= 16'h0;
            valid <= OP_NOP;
        end else begin
            case (opcode)
                OP_ENC: begin
                    // Encryption rounds
                    round0 = pbox(apply_sbox(in_data ^ round_key[0]));
                    round1 = pbox(apply_sbox(round0 ^ round_key[1]));
                    round2 = apply_sbox(round1 ^ round_key[2]);
                    round3 = round2 ^ round_key[3];

                    out_data = round3;
                    valid = OP_ENC;

                  $display("Time: %0t | ENC FROM DUT | opcode=%0b | in_data=%h | key=%h | out_data=%h | valid=%0b",
                             $time, opcode, in_data, key, round3, OP_ENC);
                end

                OP_DEC: begin
                    // Decryption inverse order
                    round3 = in_data ^ round_key[3];
                    round2 = apply_inv_sbox(round3) ^ round_key[2];
                    round1 = apply_inv_sbox(inv_pbox(round2)) ^ round_key[1];
                    round0 = apply_inv_sbox(inv_pbox(round1)) ^ round_key[0];

                    out_data = round0;
                    valid = OP_DEC;

                  $display("Time: %0t | DEC FROM DUT | opcode=%0b | in_data=%h | key=%h | out_data=%h | valid=%0b",
                             $time, opcode, in_data, key, round0, OP_DEC);
                end

                default: begin
                    out_data = 16'h0;
                    valid = OP_ERR;
                end
            endcase
        end
    end

endmodule
