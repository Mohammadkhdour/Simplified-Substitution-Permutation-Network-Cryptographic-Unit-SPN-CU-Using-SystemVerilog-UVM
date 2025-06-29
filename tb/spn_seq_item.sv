class spn_seq_item extends uvm_sequence_item;
  rand logic [1:0] opcode;   // OP_ENC = 01, OP_DEC = 10
  rand logic [15:0] in_data;
  rand logic [31:0] key;
  
  logic [15:0] out_data;
  logic [1:0] valid;

  
    `uvm_object_utils_begin(spn_seq_item)
  `uvm_field_int(opcode,UVM_ALL_ON)
  `uvm_field_int(in_data,UVM_ALL_ON)
  `uvm_field_int(key,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "spn_seq_item");
    super.new(name);
  endfunction

  constraint opcode_c { opcode inside {2'b01, 2'b10}; }
  constraint key_nonzero_c { key != 0; }
  constraint in_data_nonzero_c { in_data != 0; }
endclass
