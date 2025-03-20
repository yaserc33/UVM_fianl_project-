class testbench extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(testbench)

  
  wb_env wb;
  clock_and_reset_env clk_rst;
  spi_env spi;


  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this,"*wb*", "num_masters", 1);
    uvm_config_int::set(this,"*wb*", "num_slaves", 0);
    uvm_config_int::set(this, "*spi*", "enable_master", 0);
    uvm_config_int::set(this, "*spi*", "enable_slave", 1);

    wb = wb_env::type_id::create("wb", this);
    clk_rst = clock_and_reset_env::type_id::create("clk_rst" ,this);
    spi = spi_env::type_id::create("spi", this);

  endfunction : build_phase
 

endclass : testbench



