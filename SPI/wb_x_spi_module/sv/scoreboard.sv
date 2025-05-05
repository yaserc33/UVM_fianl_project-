class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // Analysis ports
  `uvm_analysis_imp_decl(_spi1)
  uvm_analysis_imp_spi1#(spi_transaction, scoreboard) spi_in1;

  `uvm_analysis_imp_decl(_spi2)
  uvm_analysis_imp_spi2#(spi_transaction, scoreboard) spi_in2;

  `uvm_analysis_imp_decl(_ref)
  uvm_analysis_imp_ref#(wb_transaction, scoreboard) ref_in;

  // Stats
  int total_packets_received = 0;
  int total_matched_packets  = 0;
  int total_wrong_packets    = 0;
  int total_spi_transactions = 0;
  int total_ref_transactions = 0;

  // Reference model instance 
  wb_x_spi_module ref_model;

  // Constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    spi_in1 = new("spi_in1", this);
    spi_in2 = new("spi_in2", this);
    ref_in  = new("ref_in", this);
  endfunction

  // SPI 1 callback
  function void write_spi1(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI1 Transaction: %s", t.sprint()), UVM_MEDIUM)
    ref_model.tx_queue.push_back(t.data_in);
    ref_model.rx_queue.push_back(t.data_out);
    ref_model.spi_queue.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction

  // SPI 2 callback
  function void write_spi2(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI2 Transaction: %s", t.sprint()), UVM_MEDIUM)
    ref_model.tx_queue.push_back(t.data_in);
    ref_model.rx_queue.push_back(t.data_out);
    ref_model.spi_queue.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction

  // Reference Model callback
  function void write_ref(wb_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received REF Transaction: %s", t.sprint()), UVM_MEDIUM)
    ref_model.tx_queue.push_back(t.din);
    ref_model.rx_queue.push_back(t.dout);
    ref_model.wb_queue.push_back(t);
    total_ref_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction

  // Compare logic
//  function void compare_transactions();
//    if (ref_model.wb_queue.size() > 0 ) begin
//   if (ref_model.rx_queue.size() > 0 && ref_model.tx_queue.size() > 0) begin
//      wb_transaction ref_pkt = ref_model.wb_queue.pop_front();
//     spi_transaction spi_pkt = ref_model.spi_queue.pop_front();
//     bit [7:0] ref_data_out = ref_model.rx_queue.pop_front();
//     bit [7:0] ref_din       = ref_model.tx_queue.pop_front();
     
//     if (ref_pkt.op_type == wb_read) begin
//     case (ref_pkt.addr)
//       32'h2: begin  // SPDR
//       if (ref_data_out == ref_din) begin
//         total_matched_packets++;
//         `uvm_info("SCOREBOARD", $sformatf("RX MATCH: SPI data_out = %h, WB din = %h", ref_data_out, ref_din), UVM_HIGH)
//       end else begin
//         total_wrong_packets++;
//         `uvm_error("SCOREBOARD", $sformatf("RX MISMATCH: SPI data_out = %h, WB din = %h", ref_data_out, ref_din))
//       end
//       end
      

//       32'h0: begin  // SPCR
//         if (ref_data_out == ref_model.get_SPCR()) begin
//           total_matched_packets++;
//         end else begin
//           total_wrong_packets++;
//           `uvm_error("SCOREBOARD", $sformatf("MISMATCH: REF WB = %h, REF MODEL SPCR = %h", ref_data_out, ref_model.get_SPCR()))
//         end
//       end

//       32'h1: begin  // SPSR
//         if (ref_data_out == ref_model.get_SPSR()) begin
//           total_matched_packets++;
//         end else begin
//           total_wrong_packets++;
//           `uvm_error("SCOREBOARD", $sformatf("MISMATCH: REF WB = %h, REF MODEL SPSR = %h", ref_data_out, ref_model.get_SPSR()))
//         end
//       end

//       32'h3: begin  // SPER
//         if (ref_data_out == ref_model.get_SPER()) begin
//           total_matched_packets++;
//         end else begin
//           total_wrong_packets++;
//           `uvm_error("SCOREBOARD", $sformatf("MISMATCH: REF WB = %h, REF MODEL SPER = %h", ref_data_out, ref_model.get_SPER()))
//         end
//       end

//       32'h4: begin  // CSREG
//         if (ref_data_out == ref_model.get_CSREG()) begin
//           total_matched_packets++;
//         end else begin
//           total_wrong_packets++;
//           `uvm_error("SCOREBOARD", $sformatf("MISMATCH: REF WB = %h, REF MODEL CSREG = %h", ref_data_out, ref_model.get_CSREG()))
//         end
//       end

//       default: begin
//         `uvm_warning("SCOREBOARD", $sformatf("Unhandled address in comparison: 0x%0h", ref_pkt.addr))
//       end
//     endcase

//     end 

//    end
//   else if (ref_model.rx_queue.size() == 0 || ref_model.tx_queue.size() == 0) begin
//   return;
  

//   end
//    end 
// endfunction

function void compare_transactions();
  if (ref_model.wb_queue.size() == 0)
    return;

  else begin
  wb_transaction ref_pkt = ref_model.wb_queue.pop_front();
   if (ref_pkt.op_type == wb_read) begin
  // Only expect SPI data for SPDR register 
    case (ref_pkt.addr)
      32'h0: compare_reg("SPCR", ref_pkt.dout, ref_model.get_SPCR());
      32'h1: compare_reg("SPSR", ref_pkt.dout, ref_model.get_SPSR());
       32'h2: begin // SPDR
       if (ref_model.spi_queue.size() > 0 &&
      ref_model.rx_queue.size() > 0 &&
      ref_model.tx_queue.size() > 0) begin
       
      spi_transaction spi_pkt = ref_model.spi_queue.pop_front();
      bit [7:0] ref_data_out = ref_model.rx_queue.pop_front();
      bit [7:0] ref_din = ref_model.tx_queue.pop_front();

      if (ref_data_out == ref_din) begin
        total_matched_packets++;
        `uvm_info("SCOREBOARD", $sformatf("RX MATCH: SPI data_out = %h, WB din = %h", ref_data_out, ref_din), UVM_HIGH)
      end else begin
        total_wrong_packets++;
        `uvm_error("SCOREBOARD", $sformatf("RX MISMATCH: SPI data_out = %h, WB din = %h", ref_data_out, ref_din))
      end
    end
       end 
      32'h3: compare_reg("SPER", ref_pkt.dout, ref_model.get_SPER());
      32'h4: compare_reg("CSREG", ref_pkt.dout, ref_model.get_CSREG());
     default: begin 
        `uvm_warning("SCOREBOARD", "Unhandled address in comparison");
         end 
    endcase
   
  end 
  end 
endfunction


function void compare_reg(string name, bit [7:0] actual, bit [7:0] expected);
  if (actual == expected) begin
    total_matched_packets++;
    `uvm_info("SCOREBOARD", $sformatf("MATCH: WB = %h, REF_MODEL %s = %h", actual, name, expected), UVM_HIGH)
  end else begin
    total_wrong_packets++;
    `uvm_error("SCOREBOARD", $sformatf("MISMATCH: WB = %h, REF_MODEL %s = %h", actual, name, expected))
  end
endfunction


  // Report
  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", "-------------------- SCOREBOARD REPORT --------------------", UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total SPI Transactions  : %0d", total_spi_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total REF Transactions  : %0d", total_ref_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Received Packets  : %0d", total_packets_received), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Matched Packets   : %0d", total_matched_packets), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Wrong Packets     : %0d", total_wrong_packets), UVM_LOW)
    // `uvm_info("SCOREBOARD", $sformatf("Remaining RX Queue      : %0d", ref_model.rx_queue.size()), UVM_LOW)
    // `uvm_info("SCOREBOARD", $sformatf("Remaining TX Queue      : %0d", ref_model.tx_queue.size()), UVM_LOW)
  endfunction

endclass
