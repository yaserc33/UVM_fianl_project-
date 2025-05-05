class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  spi_tb tb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
     `uvm_info("Test : ","Constructor!",UVM_LOW);
  endfunction

  function void build_phase(uvm_phase phase);

   super.build_phase(phase);
    `uvm_info("Test : ","Bulid Phase!",UVM_HIGH);
    tb = spi_tb::type_id::create("tb", this);
    uvm_config_int::set( this, "*", "recording_detail",1);
// Enable  Master
    uvm_config_int::set(this, "tb.env", "enable_master", 0);
    // uvm_config_int::set(this, "tb.env", "enable_master", 0);

   //  Enable  Slave
    uvm_config_int::set(this, "tb.*", "enable_slave", 1);
    // uvm_config_int::set(this, "tb.*", "enable_slave", 0);
    

 
endfunction


function void end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction

//run phase has to be task
virtual task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 400ns);
endtask


function void check_phase(uvm_phase phase);
check_config_usage();
endfunction

endclass


class spi_write_test extends base_test;
    `uvm_component_utils(spi_write_test)

    function new(string name = "spi_write_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      
        uvm_config_wrapper::set(this, "tb.env.master_agent.*", "default_sequence", spi_write_seq::get_type());
        uvm_config_wrapper::set(this, "tb.env.slave_agent.*", "default_sequence", spi_slave_response_seq::get_type());
        super.build_phase(phase);

      
    endfunction
endclass

class spi_read_test extends base_test;
    `uvm_component_utils(spi_read_test)

    function new(string name = "spi_read_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
       uvm_config_wrapper::set(this, "tb.env.slave_agent.*", "default_sequence", spi_slave_write_seq::get_type());
        uvm_config_wrapper::set(this, "tb.env.master_agent.*", "default_sequence", spi_master_response_seq::get_type());
       
        super.build_phase(phase);

      
    endfunction
endclass
