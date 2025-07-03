// Code your testbench here
// or browse Examples
`include "spn_if.sv"
`include "spn_seq_item.sv"
`include "spn_sequencer.sv"
`include "spn_driver.sv"
`include "spn_monitor.sv"
`include "spn_scoreboard.sv"
`include "spn_agent.sv"
`include "spn_env.sv"
`include "spn_seq.sv"
`include "spn_test.sv"
`include "spn_enc_dec_test.sv"

module tb_top;

  logic clk;
  logic reset;

  spn_if spn_vif(clk, reset);

  SPN_CU dut (
    .clk(clk),
    .reset(reset),
    .opcode(spn_vif.opcode),
    .in_data(spn_vif.in_data),
    .key(spn_vif.key),
    .out_data(spn_vif.out_data),
    .valid(spn_vif.valid)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset generation
  initial begin
    reset = 1;
    #15;
    reset = 0;
  end

  // UVM configuration to bind virtual interface
  initial begin
    uvm_config_db#(virtual spn_if)::set(null, "*", "vif", spn_vif);
  end

  // Run UVM test
  initial begin
    run_test("spn_enc_dec_test");
  end

endmodule
