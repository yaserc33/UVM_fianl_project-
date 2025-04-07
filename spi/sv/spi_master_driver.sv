class spi_master_driver extends uvm_driver #(spi_transaction);
  `uvm_component_utils(spi_master_driver)

  virtual spi_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
      if (!spi_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      if (req == null) begin
                `uvm_fatal(get_type_name(), "Received NULL transaction from sequencer")
            end
        // @(posedge vif.sclk);
        // // wait (vif.slavestart == 1);    
      vif.master_send_to_dut(req.data_in, req.data_out);
      seq_item_port.item_done();
    end
  endtask
   virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
    endfunction

endclass