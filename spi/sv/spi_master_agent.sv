class spi_master_agent extends uvm_agent;
 

  spi_master_driver driver;
  spi_master_sequencer sequencer;
  spi_master_monitor monitor;

  `uvm_component_utils_begin(spi_master_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (is_active == UVM_ACTIVE) begin
    driver = spi_master_driver::type_id::create("driver", this);
    sequencer = spi_master_sequencer::type_id::create("sequencer", this);
    end 
     monitor = spi_master_monitor::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
  if (is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end 
  endfunction

      virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
    endfunction

endclass