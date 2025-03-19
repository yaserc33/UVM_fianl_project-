class spi_slave_sequencer extends uvm_sequencer#(spi_transaction);
  `uvm_component_utils(spi_slave_sequencer)

  function new(string name = "spi_slave_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass