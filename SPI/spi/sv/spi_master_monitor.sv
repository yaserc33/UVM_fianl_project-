class spi_master_monitor extends uvm_monitor;
  `uvm_component_utils(spi_master_monitor)
 virtual spi_if vif;
//  scorboared connection 
  // uvm_analysis_port#(spi_transaction) mon_ap;
 

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // mon_ap = new("mon_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
   if (!spi_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction


      spi_transaction trans;
  virtual task run_phase(uvm_phase phase);
    forever begin
         `uvm_info("SPI_Master_MONITOR", "Monitor is active", UVM_LOW)
            @(vif.mmonstart)
      //  scorboared improvments 
      trans = spi_transaction::type_id::create("trans");
      vif.collect_packet_m(trans.data_in);
      // mon_ap.write(trans);
    end
  endtask
  virtual function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
    endfunction

endclass