
class spn_enc_dec_test extends spn_test;

  `uvm_component_utils(spn_enc_dec_test)
  
  //---------------------------------------
  // sequence instance 
  //--------------------------------------- 
  spn_encrypt_decrypt_sequence seq;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "spn_enc_dec_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the encrypt-decrypt sequence
    seq = spn_encrypt_decrypt_sequence::type_id::create("seq");
  endfunction : build_phase
  
  //---------------------------------------
  // run_phase - start the test
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      seq.start(env.agent.sequencer);
    phase.drop_objection(this);

    // Optional drain time to allow environment to settle
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  
endclass : spn_enc_dec_test
