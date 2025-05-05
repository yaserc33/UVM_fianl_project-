package spi_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  typedef uvm_config_db#(virtual spi_if) spi_vif_config;

  `include "../sv/spi_transaction.sv"
   
   //master 
  `include "../sv/spi_master_monitor.sv"
 
 `include "../sv/spi_master_seqs.sv"
 `include "../sv/spi_master_sequencer.sv"
  `include "../sv/spi_master_driver.sv"
 `include "../sv/spi_master_agent.sv"
 //slave 
 `include "../sv/spi_slave_monitor.sv"
  `include "../sv/spi_slave_sequencer.sv"
 `include "../sv/spi_slave_seqs.sv"
  `include "../sv/spi_slave_driver.sv"
 `include "../sv/spi_slave_agent.sv"
  `include "../sv/spi_env.sv"

endpackage : spi_pkg