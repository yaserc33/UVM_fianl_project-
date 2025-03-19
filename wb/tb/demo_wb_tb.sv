class demo_tb extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(demo_tb)

  // wb environment
  wb_env wb;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // This overwrites configuration from testbench    
    uvm_config_int::set(this,"*wb*", "num_masters", 1);
    uvm_config_int::set(this,"*wb*", "num_slaves", 1);
    wb = wb_env::type_id::create("wb", this);
  endfunction : build_phase
 

endclass : demo_tb



