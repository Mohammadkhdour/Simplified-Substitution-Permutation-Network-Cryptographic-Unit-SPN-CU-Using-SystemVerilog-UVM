import spn_pkg::*;
class spn_scoreboard extends uvm_scoreboard;

  //---------------------------------------
  // Queue to store transactions received from the monitor
  //---------------------------------------
  spn_seq_item pkt_qu[$];

  //---------------------------------------
  // Port to receive transactions from monitor
  //---------------------------------------
  uvm_analysis_imp#(spn_seq_item, spn_scoreboard) item_collected_export;

  `uvm_component_utils(spn_scoreboard)

  //---------------------------------------
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //---------------------------------------
  // Build phase - initialize the analysis port
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction

  //---------------------------------------
  // Write function - receives transactions and stores in queue
  //---------------------------------------
  virtual function void write(spn_seq_item pkt);
    // You can print transaction details here for debug:
    // pkt.print();
    pkt_qu.push_back(pkt);
  endfunction

  //---------------------------------------
  // Run phase - process transactions, compare expected vs actual, print results
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    spn_seq_item trans;
    logic [15:0] expected;

    forever begin
      wait(pkt_qu.size() > 0);
      trans = pkt_qu.pop_front();
      // Check and compare expected output using reference model
      if(trans.valid == OP_ENC) begin // Encryption
        expected = reference_encrypt(trans.in_data, trans.key);
        
        if (expected === trans.out_data) begin
          `uvm_info(get_type_name(),
            $sformatf("Encryption PASS: expected = %h, actual = %h for input %h with key %h",
              expected, trans.out_data, trans.in_data, trans.key),
            UVM_LOW);
        end else begin
          `uvm_error(get_type_name(),
            $sformatf("Encryption FAIL: expected = %h, actual = %h for input %h with key %h",
              expected, trans.out_data, trans.in_data, trans.key));
        end
      end else if(trans.valid == OP_DEC) begin // Decryption
        expected = reference_decrypt(trans.in_data, trans.key);
        if (expected === trans.out_data) begin
          `uvm_info(get_type_name(),
            $sformatf("Decryption PASS: expected = %h, actual = %h for input %h with key %h",
              expected, trans.out_data, trans.in_data, trans.key),
            UVM_LOW);
        end else begin
          `uvm_error(get_type_name(),
            $sformatf("Decryption FAIL: expected = %h, actual = %h for input %h with key %h",
              expected, trans.out_data, trans.in_data, trans.key));
        end
      end else begin
        `uvm_error(get_type_name(),
                   $sformatf("Invalid transaction: valid = %0b, opcode = %0b, input = %0h, key = %0h, output = %0h", trans.valid, trans.opcode, trans.in_data, trans.key, trans.out_data));
      end
    end
  endtask

endclass : spn_scoreboard
