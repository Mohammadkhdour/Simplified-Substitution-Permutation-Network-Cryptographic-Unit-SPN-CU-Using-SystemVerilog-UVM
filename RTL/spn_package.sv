// spn_package.sv
package spn_pkg;

    // Define opcodes
    typedef enum logic [1:0] {
        OP_NOP    = 2'b00,
        OP_ENC    = 2'b01,
        OP_DEC    = 2'b10,
        OP_ERR    = 2'b11
    } opcode_t;

    // Round key type
typedef logic [15:0] round_key_t [0:3];

    // S-box table (nibble substitution)
    function automatic logic [3:0] sbox(input logic [3:0] in);
        case (in)
            4'h0: sbox = 4'ha;
            4'h1: sbox = 4'h5;
            4'h2: sbox = 4'h8;
            4'h3: sbox = 4'h2;
            4'h4: sbox = 4'h6;
            4'h5: sbox = 4'hc;
            4'h6: sbox = 4'h4;
            4'h7: sbox = 4'h3;
            4'h8: sbox = 4'h1;
            4'h9: sbox = 4'h0;
            4'ha: sbox = 4'hb;
            4'hb: sbox = 4'h9;
            4'hc: sbox = 4'hf;
            4'hd: sbox = 4'hd;
            4'he: sbox = 4'h7;
            4'hf: sbox = 4'he;
            default: sbox = 4'h0;
        endcase
    endfunction

    // Inverse S-box (for decryption)
    function automatic logic [3:0] inv_sbox(input logic [3:0] in);
        case (in)
            4'ha: inv_sbox = 4'h0;
            4'h5: inv_sbox = 4'h1;
            4'h8: inv_sbox = 4'h2;
            4'h2: inv_sbox = 4'h3;
            4'h6: inv_sbox = 4'h4;
            4'hc: inv_sbox = 4'h5;
            4'h4: inv_sbox = 4'h6;
            4'h3: inv_sbox = 4'h7;
            4'h1: inv_sbox = 4'h8;
            4'h0: inv_sbox = 4'h9;
            4'hb: inv_sbox = 4'ha;
            4'h9: inv_sbox = 4'hb;
            4'hf: inv_sbox = 4'hc;
            4'hd: inv_sbox = 4'hd;
            4'h7: inv_sbox = 4'he;
            4'he: inv_sbox = 4'hf;
            default: inv_sbox = 4'h0;
        endcase
    endfunction

    // Apply S-box nibble-wise on 16-bit data
    function automatic logic [15:0] apply_sbox(input logic [15:0] data);
        apply_sbox = {
            sbox(data[15:12]),
            sbox(data[11:8]),
            sbox(data[7:4]),
            sbox(data[3:0])
        };
    endfunction

    // Apply inverse S-box nibble-wise on 16-bit data
    function automatic logic [15:0] apply_inv_sbox(input logic [15:0] data);
        apply_inv_sbox = {
            inv_sbox(data[15:12]),
            inv_sbox(data[11:8]),
            inv_sbox(data[7:4]),
            inv_sbox(data[3:0])
        };
    endfunction

    // Permutation and inverse permutation (swap bytes)
    function automatic logic [15:0] pbox(input logic [15:0] data);
        return {data[7:0], data[15:8]}; // rotate left 8 bits (swap bytes)
    endfunction

    function automatic logic [15:0] inv_pbox(input logic [15:0] data);
        return {data[7:0], data[15:8]}; // same as pbox (swap bytes)
    endfunction


// Reference encryption model (pure function)
function automatic logic [15:0] reference_encrypt(input logic [15:0] data_in, logic [31:0] key);
        logic [15:0] round_key[0:3];
        logic [15:0] round0, round1, round2, round3;

        // Generate round keys (same as DUT)
        round_key[0] = {key[7:0],  key[23:16]};
        round_key[1] = key[15:0];
        round_key[2] = {key[7:0],  key[31:24]};
        round_key[3] = key[31:16];

        // Encryption rounds same as DUT
  round0 = pbox(apply_sbox(data_in ^ round_key[0]));
        round1 = pbox(apply_sbox(round0 ^ round_key[1]));

        round2 = apply_sbox(round1 ^ round_key[2]);

        round3 = round2 ^ round_key[3]; // final whitening key

        return round3;
    endfunction

    // Reference decryption model (pure function)
function automatic logic [15:0] reference_decrypt(input logic [15:0] data_in, logic [31:0] key);
        logic [15:0] round_key[0:3];
        logic [15:0] round0, round1, round2, round3;

        // Generate round keys (same as DUT)
        round_key[0] = {key[7:0],  key[23:16]};
        round_key[1] = key[15:0];
        round_key[2] = {key[7:0],  key[31:24]};
        round_key[3] = key[31:16];

        // Decryption rounds same as DUT
        round3 = data_in ^ round_key[3];
        round2 = apply_inv_sbox(round3) ^ round_key[2];
        round1 = apply_inv_sbox(inv_pbox(round2)) ^ round_key[1];
        round0 = apply_inv_sbox(inv_pbox(round1)) ^ round_key[0];

        return round0;
    endfunction





endpackage
