class spn_env extends uvm_env;

  spn_agent agent;
  spn_scoreboard scoreboard;

  `uvm_component_utils(spn_env)

  function new(string name = "spn_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = spn_agent::type_id::create("agent", this);
    scoreboard = spn_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
  endfunction

endclass
