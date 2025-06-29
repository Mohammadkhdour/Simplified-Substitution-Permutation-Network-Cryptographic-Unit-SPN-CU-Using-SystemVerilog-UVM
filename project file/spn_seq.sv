
//=========================================================================
// spn_sequence - random encrypt or decrypt stimulus
//=========================================================================
class spn_sequence extends uvm_sequence#(spn_seq_item);
  
  `uvm_object_utils(spn_sequence)
  `uvm_declare_p_sequencer(spn_sequencer)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name = "spn_sequence");
    super.new(name);
  endfunction
  
  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
    repeat(5) begin
      spn_seq_item req = spn_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass
//=========================================================================


//=========================================================================
// spn_encrypt_sequence - encrypt only
//=========================================================================
class spn_encrypt_sequence extends uvm_sequence#(spn_seq_item);
  
  `uvm_object_utils(spn_encrypt_sequence)
  `uvm_declare_p_sequencer(spn_sequencer)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name = "spn_encrypt_sequence");
    super.new(name);
  endfunction
  
  //---------------------------------------
  // Send encrypt requests only
  //---------------------------------------
  virtual task body();
    `uvm_do_with(req, {req.opcode == 2'b01;})
  endtask
endclass
//=========================================================================


//=========================================================================
// spn_decrypt_sequence - decrypt only
//=========================================================================
class spn_decrypt_sequence extends uvm_sequence#(spn_seq_item);
  
  `uvm_object_utils(spn_decrypt_sequence)
  `uvm_declare_p_sequencer(spn_sequencer)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name = "spn_decrypt_sequence");
    super.new(name);
  endfunction
  
  //---------------------------------------
  // Send decrypt requests only
  //---------------------------------------
  virtual task body();
    `uvm_do_with(req, {req.opcode == 2'b10;})
  endtask
endclass
//=========================================================================


//=========================================================================
// spn_encrypt_decrypt_sequence - encrypt followed by decrypt
//=========================================================================
class spn_encrypt_decrypt_sequence extends uvm_sequence#(spn_seq_item);
  
  `uvm_object_utils(spn_encrypt_decrypt_sequence)
  `uvm_declare_p_sequencer(spn_sequencer)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name = "spn_encrypt_decrypt_sequence");
    super.new(name);
  endfunction
  
  //---------------------------------------
  // Send encrypt then decrypt requests
  //---------------------------------------
  virtual task body();
    repeat(5)begin
    `uvm_do_with(req, {req.opcode == 2'b01;}) // encrypt
    `uvm_do_with(req, {req.opcode == 2'b10;}) // decrypt
    end
  endtask
endclass
//=========================================================================


//=========================================================================
// spn_wr_rd_sequence - encrypt sequence followed by decrypt sequence
//=========================================================================
class spn_wr_rd_sequence extends uvm_sequence#(spn_seq_item);

  spn_encrypt_sequence enc_seq;
  spn_decrypt_sequence dec_seq;

  `uvm_object_utils(spn_wr_rd_sequence)
  `uvm_declare_p_sequencer(spn_sequencer)

  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name = "spn_wr_rd_sequence");
    super.new(name);
  endfunction

  //---------------------------------------
  // Run encrypt sequence then decrypt sequence
  //---------------------------------------
  virtual task body();
    `uvm_do(enc_seq)
    `uvm_do(dec_seq)
  endtask
endclass
//=========================================================================
