class spi_slave_agent extends uvm_agent;


  spi_slave_driver drv;
  spi_slave_monitor mon;
  spi_slave_sequencer seqr;

    `uvm_component_utils_begin(spi_slave_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end
  
  function new(string name = "spi_slave_agent",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if (is_active == UVM_ACTIVE) begin
    drv = spi_slave_driver::type_id::create("drv",this);
    seqr = spi_slave_sequencer::type_id::create("seqr",this);
     end 
     mon = spi_slave_monitor::type_id::create("mon",this);

  endfunction

  function void connect_phase(uvm_phase phase);
  if (is_active == UVM_ACTIVE) begin
    drv.seq_item_port.connect(seqr.seq_item_export);
  end 
  endfunction
endclass