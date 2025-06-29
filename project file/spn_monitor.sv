class spn_monitor extends uvm_monitor;

  virtual spn_if vif;
  uvm_analysis_port#(spn_seq_item) item_collected_port;

  `uvm_component_utils(spn_monitor)
  
  spn_seq_item trans_collected;

  function new(string name = "spn_monitor", uvm_component parent = null);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual spn_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction

virtual task run_phase(uvm_phase phase);

  forever begin
    @(posedge vif.MONITOR.clk);

    // Wait until an operation (encrypt or decrypt) is requested
    wait(vif.monitor_cb.opcode == 2'b01 || vif.monitor_cb.opcode == 2'b10);

    // Sample inputs from clocking block (synchronized to clock)
    trans_collected.opcode  = vif.monitor_cb.opcode;
    trans_collected.in_data = vif.monitor_cb.in_data;
    trans_collected.key     = vif.monitor_cb.key;

    // For encryption/decryption, wait one or two cycles for output and valid to update
    @(posedge vif.MONITOR.clk);
   @(posedge vif.MONITOR.clk);
    trans_collected.out_data = vif.monitor_cb.out_data;
        trans_collected.valid = vif.monitor_cb.valid;



    // Write the transaction to analysis port
    item_collected_port.write(trans_collected);
    
  end
endtask : run_phase


endclass
