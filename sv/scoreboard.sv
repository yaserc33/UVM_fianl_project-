class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // Analysis ports
  `uvm_analysis_imp_decl(_spi1)
  uvm_analysis_imp_spi1#(spi_transaction, scoreboard) spi_in1;

  `uvm_analysis_imp_decl(_spi2)
  uvm_analysis_imp_spi2#(spi_transaction, scoreboard) spi_in2;

  `uvm_analysis_imp_decl(_wb)
  uvm_analysis_imp_wb#(wb_transaction, scoreboard) wb_in;

  // Transaction queues
  spi_transaction spi_queue_1[$];
  spi_transaction spi_queue_2[$];
  wb_transaction  wb_queue[$];

  // Stats
  int total_packets_received = 0;
  int total_matched_packets  = 0;
  int total_wrong_packets    = 0;
  int total_spi_transactions = 0;
  int total_wb_transactions  = 0;

  // Constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    spi_in1 = new("spi_in1", this);
    spi_in2 = new("spi_in2", this);
    wb_in   = new("wb_in", this);
  endfunction

  // SPI 1 callback
  function void write_spi1(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI1 Transaction: %s", t.sprint()), UVM_MEDIUM)
    spi_queue_1.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction

  // SPI 2 callback
  function void write_spi2(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI2 Transaction: %s", t.sprint()), UVM_MEDIUM)
    spi_queue_2.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction

  // WB callback
  function void write_wb(wb_transaction t);
    if (t.valid_sb == 1'b1) begin
    `uvm_info("SCOREBOARD", $sformatf("Received WB Transaction: %s", t.sprint()), UVM_MEDIUM)
    wb_queue.push_back(t);
    total_wb_transactions++;
    total_packets_received++;
    compare_transactions();
    end 
  endfunction

  // Compare logic
  function void compare_transactions();
    if (wb_queue.size() > 0 &&
        (spi_queue_1.size() > 0 || spi_queue_2.size() > 0)) begin

      spi_transaction spi_pkt;
      wb_transaction wb_pkt = wb_queue.pop_front();
      if (spi_queue_1.size() > 0)
        spi_pkt = spi_queue_1.pop_front();
      else
        spi_pkt = spi_queue_2.pop_front();

      

      if (wb_pkt.op_type == wb_write) begin
        if (spi_pkt.data_in == wb_pkt.dout) begin
          total_matched_packets++;
          `uvm_info("SCOREBOARD", $sformatf("MATCH : SPI = %h, WB = %h", spi_pkt.data_in, wb_pkt.dout), UVM_HIGH)
        end else begin
          total_wrong_packets++;
          `uvm_error("SCOREBOARD", $sformatf("MISMATCH : SPI = %h, WB = %h", spi_pkt.data_in, wb_pkt.dout))
        end
      end
      else if (wb_pkt.op_type == wb_read) begin
        if (spi_pkt.data_out == wb_pkt.din) begin
          total_matched_packets++;
          `uvm_info("SCOREBOARD", $sformatf("MATCH : SPI = %h, WB = %h", spi_pkt.data_out, wb_pkt.din), UVM_HIGH)
        end else begin
          total_wrong_packets++;
          `uvm_error("SCOREBOARD", $sformatf("MISMATCH: SPI = %h, WB = %h", spi_pkt.data_out, wb_pkt.din))
        end
      end
    end
  endfunction

  // Report
  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", "-------------------- SCOREBOARD REPORT --------------------", UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total SPI Transactions  : %0d", total_spi_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total WB Transactions   : %0d", total_wb_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Received Packets  : %0d", total_packets_received), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Matched Packets   : %0d", total_matched_packets), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Wrong Packets     : %0d", total_wrong_packets), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Remaining WB Queue      : %0d", wb_queue.size()), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Remaining SPI1 Queue    : %0d", spi_queue_1.size()), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Remaining SPI2 Queue    : %0d", spi_queue_2.size()), UVM_LOW)
  endfunction

endclass
