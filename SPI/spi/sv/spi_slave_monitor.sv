// class spi_slave_monitor extends uvm_monitor;
//   `uvm_component_utils(spi_slave_monitor)

//   // uvm_analysis_port#(spi_transaction) mon_ap;
//   virtual spi_if vif;
//    // Analysis port declaration
//     uvm_analysis_port#(spi_transaction) spi_out;
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//     spi_out = new("spi_out", this);
//   endfunction

//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     // mon_ap = new("mon_ap", this);
//   endfunction

//   function void connect_phase(uvm_phase phase);
//     if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
//       `uvm_fatal("NOVIF", "No virtual interface set for SPI Monitor")
//   endfunction


//       spi_transaction trans;
//   virtual task run_phase(uvm_phase phase);
//     forever begin
//           `uvm_info("SPI_SLAVE_MONITOR", "Monitor is active", UVM_LOW)
//             @(vif.smonstart)
      
//       trans = spi_transaction::type_id::create("trans");
//       vif.collect_packet_s(trans.data_in);
//       //  scorboared improvments 
//       spi_out.write(trans);
//     end
//   endtask
//   virtual function void start_of_simulation_phase(uvm_phase phase);
//         `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
//     endfunction
// endclass
class spi_slave_monitor extends uvm_monitor;
  `uvm_component_utils(spi_slave_monitor)

  virtual spi_if vif;

  // Analysis port to connect monitor to scoreboard
  uvm_analysis_port#(spi_transaction) spi_out;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    spi_out = new("spi_out", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "No virtual interface set for SPI Monitor")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      spi_transaction trans;
      trans = spi_transaction::type_id::create("trans");

      // Wait for SPI transaction start (CS LOW)
      wait (vif.smonstart);
      `uvm_info(get_type_name(), "SPI Slave Monitor Detected CS LOW - Capturing Data", UVM_MEDIUM)

       vif.collect_packet_s(trans.data_in,trans.data_out);
       wait (!vif.smonstart);
      `uvm_info(get_type_name(), $sformatf("Transaction Collected: %h", trans.data_in), UVM_MEDIUM)
      
      spi_out.write(trans);
    end
  endtask

  

  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
  endfunction
endclass