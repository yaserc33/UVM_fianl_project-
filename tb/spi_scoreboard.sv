class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)

    // Declare analysis implementation objects
    `uvm_analysis_imp_decl(_spi)
    uvm_analysis_imp_spi#(spi_transaction, spi_scoreboard) 
    spi_in=new("spi_in", this);

    `uvm_analysis_imp_decl(_wb)
    uvm_analysis_imp_wb#(wb_transaction, spi_scoreboard) 
    wb_in=new("wb_in", this);
   

    // Scoreboard Data Structures
    spi_transaction spi_queue[$];  
    wb_transaction wb_queue[$];   

     //Declare a handle for scoreboard
     spi_scoreboard scoreboard;

    // Counters for analysis
    int total_packets_received=0;
    int total_matched_packets=0;
    int total_wrong_packets=0;
    int   total_spi_transactions=0;
    int  total_wb_transactions=0; 
     // Constructor
    function new(string name = "spi_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

     // Transaction Capturing - SPI
    function void write_spi(spi_transaction t);
        `uvm_info("SCOREBOARD", $sformatf("Received SPI Transaction: %s", t.sprint()), UVM_MEDIUM)
        spi_queue.push_back(t);
          total_spi_transactions++;
        total_packets_received++;
        compare_transactions();
    endfunction

    // Transaction Capturing - WB
    function void write_wb(wb_transaction t);
       
        // Ignore WB dummy writes or reads
        if (t.valid_sb == 1'b1) begin
        //     `uvm_info("SCOREBOARD", "Ignoring WB Dummy Write for Read Transaction", UVM_LOW)
        //     return;
        // end
        // else begin 
        `uvm_info("SCOREBOARD", $sformatf("Received WB Transaction: %s", t.sprint()), UVM_MEDIUM)
        wb_queue.push_back(t);
                  
             total_wb_transactions++;
        total_packets_received++;
        compare_transactions();
        end 
    endfunction

    // Compare Transactions
    function void compare_transactions();
        if (spi_queue.size() > 0 && wb_queue.size() > 0) begin
            spi_transaction spi_pkt = spi_queue.pop_front();
            wb_transaction wb_pkt = wb_queue.pop_front();
            if (wb_pkt.op_type==wb_write)begin 
            if (spi_pkt.data_in == wb_pkt.dout) begin
                `uvm_info("SCOREBOARD", $sformatf("MATCH: SPI = %h, WB = %h", spi_pkt.data_in, wb_pkt.dout), UVM_HIGH)
                total_matched_packets++;
            end
            end  
            else if  (wb_pkt.op_type==wb_read)begin 
            if (spi_pkt.data_out == wb_pkt.din) begin
                `uvm_info("SCOREBOARD", $sformatf("MATCH: SPI = %h, WB = %h", spi_pkt.data_in, wb_pkt.dout), UVM_HIGH)
                total_matched_packets++;
            end
            end 
            else begin
                `uvm_error("SCOREBOARD", $sformatf("MISMATCH: SPI = %h, WB = %h", spi_pkt.data_in, wb_pkt.dout))
                total_wrong_packets++;
               
            end
        end
    endfunction
    
    // report 
     function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", "--------------------SCOREBOARD REPORT--------------------:            ", UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total SPI Packets Received: %0d", total_spi_transactions), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total WB Packets Received: %0d", total_wb_transactions), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total Packets Received: %0d", total_packets_received), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total Matched Packets: %0d", total_matched_packets), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total Wrong Packets: %0d", total_wrong_packets), UVM_LOW)

    endfunction

    endclass :spi_scoreboard

    
