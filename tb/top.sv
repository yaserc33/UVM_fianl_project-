`timescale 1ns/1ns

module top;

  // UVM class library compiled in a package
  import uvm_pkg::*;

  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"
  import wb_pkg::*;
  import clock_and_reset_pkg::*;
  import clock_and_reset_pkg::*;
  import spi_pkg::*;
  
    //include Scoreboard 
  `include "spi_scoreboard.sv"
  `include "../sv/mc_sequencer.sv"
  `include "../sv/mc_seq_lib.sv"
  `include "testbench.sv"
  `include "test_lib.sv"


  
  initial begin
    wb_vif_config::set(null,"*.tb.wb.*","vif", hw_top.wif);
    clock_and_reset_vif_config::set(null , "*clk_rst*" , "vif" , hw_top.cr_if);
    spi_vif_config::set(null,"*spi.slave_agent.*","vif", hw_top.sif);

    run_test();
  end




  initial begin
  $dumpfile("wave.vcd");
  $dumpvars;
  end

endmodule:top
