
class spn_test extends uvm_test;

  `uvm_component_utils(spn_test)
  
  //---------------------------------------
  // env instance 
  //--------------------------------------- 
  spn_env env;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "spn_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the env
    env = spn_env::type_id::create("env", this);
  endfunction : build_phase
  
  //---------------------------------------
  // end_of_elaboration phase
  //---------------------------------------  
  virtual function void end_of_elaboration();
    // Print testbench component hierarchy
    print();
  endfunction

  //---------------------------------------
  // report_phase
  //---------------------------------------   
  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    
    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end else begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 

endclass : spn_test
