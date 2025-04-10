class spi_env extends uvm_env;


  spi_master_agent master_agent;
  spi_slave_agent slave_agent;

  
  protected int unsigned  enable_master = 0; // Master ON
  protected int unsigned  enable_slave = 1;  // Slave ON

  `uvm_component_utils_begin(spi_env)
    `uvm_field_int(enable_master, UVM_ALL_ON)
    `uvm_field_int(enable_slave, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(enable_master)begin 
    master_agent = spi_master_agent::type_id::create("master_agent", this);
    end 
    if(enable_slave) begin
     slave_agent = spi_slave_agent::type_id::create("slave_agent", this);
    end 
  endfunction
endclass