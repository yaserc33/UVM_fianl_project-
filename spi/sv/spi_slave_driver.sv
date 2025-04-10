class spi_slave_driver extends uvm_driver#(spi_transaction);
  `uvm_component_utils(spi_slave_driver)

  virtual spi_if vif;

  function new(string name = "spi_slave_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
      `uvm_fatal("SPI_SLAVE_DRIVER", "No interface found")
  endfunction

  virtual task run_phase(uvm_phase phase);
    // forever begin
     
       
    //     `uvm_info(get_type_name(), "SPI Slave Detected Master Start - Preparing Response", UVM_MEDIUM)
    //    //master to slave  uvcs connction mode
    //      if(vif.enable_loopback)begin 
    //     @(posedge vif.sclk);
    //     wait (vif.masterstart == 1); // Ensure master completes sending
    //     end 
      

    //  seq_item_port.get_next_item(req);
    //   if (req == null) begin
    //             `uvm_fatal(get_type_name(), "Received NULL transaction from sequencer")
    //         end
    //   vif.slave_receive_from_dut(req.data_out, req.data_in);
    //   seq_item_port.item_done();
    // end
    forever begin
      seq_item_port.get_next_item(req);
      if (req == null) begin
                `uvm_fatal(get_type_name(), "Received NULL transaction from sequencer")
            end
      `uvm_info(get_type_name(), req.sprint() ,UVM_MEDIUM)
      vif.slave_receive_from_dut(req.data_in, req.data_out);
      seq_item_port.item_done();
    end
  endtask

   virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
    endfunction

    endclass