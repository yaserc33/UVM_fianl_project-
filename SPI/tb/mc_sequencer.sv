class mc_sequencer extends uvm_sequencer;
    
    `uvm_component_utils(mc_sequencer)


   //declare all the seqer u plan to use 
   wb_master_sequencer wb_seqr;
   spi_slave_sequencer   spi1_seqr;
   spi_slave_sequencer   spi2_seqr;
   
    function new(string name = "mc_sequencer" , uvm_component parent );
    super.new(name, parent);        
    endfunction :new



endclass:mc_sequencer