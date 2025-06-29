interface spn_if(input logic clk, reset);

  //---------------------------------------
  // Declaring the signals
  //---------------------------------------
  logic [1:0] opcode;
  logic [15:0] in_data;
  logic [31:0] key;
  logic [15:0] out_data;
  logic [1:0] valid;

  //---------------------------------------
  // Driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output opcode;
    output in_data;
    output key;
    input  out_data;
    input  valid;
  endclocking

  //---------------------------------------
  // Monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input opcode;
    input in_data;
    input key;
    input out_data;
    input valid;
  endclocking

  //---------------------------------------
  // Driver modport
  //---------------------------------------
  modport DRIVER (clocking driver_cb, input clk, reset);

  //---------------------------------------
  // Monitor modport
  //---------------------------------------
  modport MONITOR (clocking monitor_cb, input clk, reset);

endinterface
