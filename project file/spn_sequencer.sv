class spn_sequencer extends uvm_sequencer#(spn_seq_item);
  `uvm_component_utils(spn_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
