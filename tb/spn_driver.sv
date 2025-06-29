`define DRIV_IF vif.DRIVER.driver_cb

class spn_driver extends uvm_driver#(spn_seq_item);

  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual spn_if vif;
  `uvm_component_utils(spn_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual spn_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // Run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(),
            $sformatf("[%0t] DRIVER: Driving input=0x%0h, key=0x%0h, opcode=%0d",
              $time, req.in_data, req.key, req.opcode),
            UVM_LOW);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  //---------------------------------------
  // Drive - transaction level to signal level
  // Drives the values from seq_item to interface signals via clocking block
  //---------------------------------------
  virtual task drive();
    // De-assert opcode and inputs initially
    `DRIV_IF.opcode <= 2'b00;
    `DRIV_IF.in_data <= 16'b0;
    `DRIV_IF.key <= 32'b0;
    @(posedge vif.DRIVER.clk);

    // Drive inputs from the transaction item
    `DRIV_IF.opcode <= req.opcode;
    `DRIV_IF.in_data <= req.in_data;
    `DRIV_IF.key <= req.key;
    @(posedge vif.DRIVER.clk);

    // Clear opcode and inputs to no-op to avoid repeated triggering
    `DRIV_IF.opcode <= 2'b00;
    `DRIV_IF.in_data <= 16'b0;
    `DRIV_IF.key <= 32'b0;
    @(posedge vif.DRIVER.clk);
  endtask : drive
endclass : spn_driver
