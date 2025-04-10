class spi_master_sequencer extends uvm_sequencer #(spi_transaction);
  `uvm_component_utils(spi_master_sequencer)
 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass