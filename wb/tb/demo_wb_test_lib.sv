class demo_base_test extends uvm_test;

  `uvm_component_utils(demo_base_test)

  demo_tb tb;

  function new(string name = "demo_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_int::set(this,"*", "recording_detail", UVM_FULL);
    // Create the tb
    tb = demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

endclass : demo_base_test




//----------------------------------------------------------------
// TEST: write-read  write  1 byte to data register of spi  then read 1 byte from it  
//----------------------------------------------------------------
class wb_write_read_test extends demo_base_test;

  `uvm_component_utils(wb_write_read_test)

  function new(string name = get_type_name(), uvm_component parent=null);
    super.new(name,parent);
  endfunction : new




  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
  endtask : run_phase


  virtual function void build_phase(uvm_phase phase);

    // Set the default sequence for the master and slave
    uvm_config_wrapper::set(this, "tb.wb.masters[0].sequencer.main_phase",
                            "default_sequence",
                            wb_write_read_seq::get_type());



    super.build_phase(phase);
  endfunction : build_phase

endclass : wb_write_read_test





//----------------------------------------------------------------
// TEST: write-to all the address test  
//----------------------------------------------------------------
class wb_all_address_test extends demo_base_test;

  `uvm_component_utils(wb_all_address_test)

  function new(string name = "wb_all_address_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new




  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
  endtask : run_phase


  virtual function void build_phase(uvm_phase phase);
    
    // This overwrites configuration from testbench    
    uvm_config_int::set(this,"*tb.wb*", "num_masters", 1);
    uvm_config_int::set(this,"*tb.wb*", "num_slaves", 1);

    // Set the default sequence for the master and slave
    uvm_config_wrapper::set(this, "tb.wb.masters[0].sequencer.main_phase",
                            "default_sequence",
                            wb_all_address_seq::get_type());



    // no need for sequence to run in slave

   
    super.build_phase(phase);
  endfunction : build_phase

endclass : wb_all_address_test
