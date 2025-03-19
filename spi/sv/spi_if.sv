interface spi_if(input logic clock, input logic reset, input  logic sclk);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import spi_pkg::*;

  // SPI 
 
  logic        cs;
  logic        mosi;
  logic        miso;
  logic cpol, cpha;  // CPOL and CPHA (clock phase and polartiy)

  // Transaction triggers
  bit masterstart, slavestart;
 bit mmonstart,smonstart;
  // LoopBack Mode
  bit  enable_loopback=1; //defualt off 

 

    // // SPI Clock Generation (Mode 0: CPOL=0, CPHA=0)
    // always @(posedge clock or negedge reset) begin
    //     if (!reset)
    //         sclk <= 0;  // Reset SCLK 
    //     else if (!cs)   // Toggle only when CS is LOW
    //         sclk <= ~sclk;
    // end


  //TASKS 
  // Master Reset Task
  task master_reset();
      @(posedge reset);
      `uvm_info("SPI_IF", "Master Observed Reset", UVM_MEDIUM)
      cs     <= 1'b1;
      mosi   <= 1'b0;
      masterstart = 1'b0;
  endtask : master_reset

  // Slave Reset Task
  task slave_reset();
      @(posedge reset);
      `uvm_info("SPI_IF", "Slave Observed Reset", UVM_MEDIUM)
      miso      <= 1'b0;
      slavestart = 1'b0;
  endtask : slave_reset

  // Master sends a transaction to the DUT
  task master_send_to_dut(input bit [7:0] data, output bit [7:0] received_data);
   
    cs <= 1'b0; // Select SPI Slave

    `uvm_info("SPI_IF", $sformatf("Master sending data: %h", data), UVM_MEDIUM)
    
    for (int i = 7; i >= 0; i--) begin
        mosi <= data[i];
    //    #5 
       @(posedge sclk);  // Mode 0: Sample on Rising Edge
        // if (enable_loopback) begin
        //     miso = mosi; // loopback no dut 
        // end
        received_data[i] = miso; // Capture received data from slave
    end
     masterstart = 1'b1;
    
    cs <= 1'b1; // Deselect SPI Slave
    masterstart = 1'b0;
      smonstart = 1'b1;
   mmonstart = 1'b1;
    `uvm_info("SPI_IF", $sformatf("Master received data: %h", received_data), UVM_MEDIUM)
  endtask : master_send_to_dut

  // Slave receives a transaction from the master
  task slave_receive_from_dut(output bit [7:0] received_data, input bit [7:0] response_data);
    slavestart = 1'b1;
    cs <= 1'b0; 
      `uvm_info( "SPI_IF","SPI Slave Interface Task ", UVM_MEDIUM)
    for (int i = 7; i >= 0; i--) begin
    //   #5 
       @(posedge sclk); 
        received_data[i] = mosi;
        //  if (enable_loopback)
        //  begin
        //    #5
         // @(negedge sclk) //ensure cycle after
        //     miso = mosi;  //no dut 
        // end else
         begin
            miso <= response_data[i];  // Send back data to master
        end
    end

    slavestart = 1'b0;
    cs <= 1'b1; 
   smonstart = 1'b1;
   mmonstart = 1'b1;
  endtask : slave_receive_from_dut

  // Collect packets for monitoring
  task collect_packet_m(output bit [7:0] data);
    
    for (int i = 7; i >= 0; i--) begin
        //  #5 
         @(posedge sclk);
        data[i] = miso;
    end
    // mmonstart = 1'b0;
    `uvm_info("SPI_IF", $sformatf("Master Monitor collected SPI transaction: %h", data), UVM_MEDIUM)
  endtask : collect_packet_m
  task collect_packet_s(output bit [7:0] data);
    
    for (int i = 7; i >= 0; i--) begin
        //  #5 
         @(posedge sclk);
        data[i] = mosi;
    end
    smonstart = 1'b0;
    `uvm_info("SPI_IF", $sformatf("Slave Monitor collected SPI transaction: %h", data), UVM_MEDIUM)
  endtask : collect_packet_s


endinterface : spi_if
