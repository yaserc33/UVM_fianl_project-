class spi_tb extends uvm_env;
`uvm_component_utils(spi_tb)
// Declare a handle for spi_env
spi_env env;
//constructor 
function new (string name= "spi_tb", uvm_component parent);
super.new(name, parent);
 `uvm_info("testbench : ","Constructor!",UVM_LOW);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase (phase);
`uvm_info("testbench : ","Bulid Phase!",UVM_HIGH);
env = spi_env::type_id::create("env", this);
endfunction

virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
endfunction

endclass 
