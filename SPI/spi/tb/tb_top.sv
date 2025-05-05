module tb_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;
  `include "uvm_macros.svh"

typedef uvm_config_db#(virtual spi_if) spi_vif_config;

  import spi_pkg::*;
  `include "spi_tb.sv"
  `include "spi_test_lib.sv"
  
  
  
  initial begin
    // Set spi interface for monitor & driver
    spi_vif_config::set(null,"*env.master_agent.*","vif",hw_top.in0);
    spi_vif_config::set(null,"*env.slave_agent.*","vif", hw_top.in0);
    run_test();
  end

  initial begin 
    $dumpfile("wav.vcd");
    $dumpvars;

  end

 

endmodule