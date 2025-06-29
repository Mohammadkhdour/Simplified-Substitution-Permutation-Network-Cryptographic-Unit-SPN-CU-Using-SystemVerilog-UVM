class spn_agent extends uvm_agent;

  spn_driver driver;
  spn_monitor monitor;
  spn_sequencer sequencer;

  `uvm_component_utils(spn_agent)

  function new(string name = "spn_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = spn_sequencer::type_id::create("sequencer", this);
     if(get_is_active() == UVM_ACTIVE) begin
    driver = spn_driver::type_id::create("driver", this);
    monitor = spn_monitor::type_id::create("monitor", this);
     end
  endfunction

  function void connect_phase(uvm_phase phase);
     if(get_is_active() == UVM_ACTIVE)
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
