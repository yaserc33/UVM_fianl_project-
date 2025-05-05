class testbench extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(testbench)


  wb_env wb;
  clock_and_reset_env clk_rst;
  spi_env spi1;
  spi_env spi2;
  mc_sequencer mc_seqr;

//replace handle for scoreboard with refrence env 
   spi_module spiref;

  // Constructor - required syntax for UVM automation and utilities
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "*wb*", "num_masters", 1);
    uvm_config_int::set(this, "*wb*", "num_slaves", 0);
    uvm_config_int::set(this, "*spi*", "enable_master", 0);
    uvm_config_int::set(this, "*spi*", "enable_slave", 1);

    wb = wb_env::type_id::create("wb", this);
    clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);
    spi1 = spi_env::type_id::create("spi1", this);
    spi2 = spi_env::type_id::create("spi2", this);
    mc_seqr = mc_sequencer::type_id::create("mc_seqr", this);

  // Create Scoreboard env 
  spiref=spi_module::type_id::create("spiref", this);
  endfunction : build_phase



  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //sequencers connection to mc_seqr
    mc_seqr.spi1_seqr =spi1.slave_agent.seqr;
    mc_seqr.spi2_seqr =spi2.slave_agent.seqr;
    mc_seqr.wb_seqr = wb.masters[0].sequencer;

    //Scoreboard connection 
    // TLM connections between spi and Scoreboard
    spi1.slave_agent.mon.spi_out.connect(spiref.myscoreboard.spi_in1); 
    spi2.slave_agent.mon.spi_out.connect(spiref.myscoreboard.spi_in2); 
    // TLM connections between wb and Refrence model
    wb.masters[0].monitor.item_collected_port.connect(spiref.sref_model.wb_in);
   // TLM connections between Refrence model and scoreborad 
    spiref.sref_model.ref_analysis_port.connect(spiref.myscoreboard.ref_in);

    `uvm_info(get_type_name(), "connect_phase 🧑🏻‍⚖️", UVM_FULL)
  endfunction : connect_phase





endclass : testbench