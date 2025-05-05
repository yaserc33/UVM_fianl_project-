`timescale 1ns/1ns

module demo_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;

  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"

  import wb_pkg::*;
  `include "demo_wb_tb.sv"
  `include "demo_wb_test_lib.sv"
  
  bit reset, clock;

  wb_if hif();
  
  initial begin
    wb_vif_config::set(null,"*.tb.wb.*","vif", hif);
    run_test();
  end


  //Generate Clock
  initial hif.clk =0;
  always #5 hif.clk = ~hif.clk;


  initial begin
  $dumpfile("wave.vcd");
  $dumpvars;
  end

endmodule:demo_top
