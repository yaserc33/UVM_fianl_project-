class spi_master_base_seq extends uvm_sequence #(spi_transaction);
  `uvm_object_utils(spi_master_base_seq)

  function new(string name = "spi_master_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body
  virtual task body();
    spi_transaction req;
    `uvm_info(get_type_name(), "Executing SPI Master Base Sequence", UVM_LOW)

    req = spi_transaction::type_id::create("req");
    start_item(req);
    if (!req.randomize()) begin
      `uvm_error(get_type_name(), "Randomization failed")
    end
    finish_item(req);
  endtask
endclass


class spi_write_seq extends spi_master_base_seq;
    `uvm_object_utils(spi_write_seq)

    spi_transaction req;  

    function new(string name = "spi_write_seq");
        super.new(name);
      endfunction

    virtual task body();
   
        `uvm_info(get_type_name(), "Executing SPI Write Sequence", UVM_LOW)

        // if (req == null) begin
        //     `uvm_fatal(get_type_name(), "Transaction object req is NULL!")
        // end

        req = spi_transaction::type_id::create("req");  
        start_item(req); 

        if (!req.randomize() with { req.data_in == 8'h1A; }) begin
            `uvm_error(get_type_name(), "Randomization failed")
        end

        finish_item(req);  

        `uvm_info(get_type_name(), $sformatf("Sent SPI Write Data: %h", req.data_in), UVM_MEDIUM)
    endtask
endclass

//response with slave raising objection 
class spi_master_response_seq extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(spi_master_response_seq)
    

    function new(string name = "spi_master_response_seq");
        super.new(name);
    endfunction
     spi_transaction req;
    virtual task body();
        
        `uvm_info(get_type_name(), "Executing SPI master Response Sequence", UVM_LOW)

        
          
        //       req = spi_transaction::type_id::create("req");
        //     start_item(req);
        //   if (!req.randomize() with { req.data_in == 8'h1; }) begin
        //     `uvm_error(get_type_name(), "Randomization failed")
        // end
          
        //     finish_item(req);
         forever begin
      // send data back to master 
            req = spi_transaction::type_id::create("req");
            start_item(req);
       if (!req.randomize() with { req.data_in == 8'h2; }) begin
            `uvm_error(get_type_name(), "Randomization failed")
        end
        `uvm_do(req)
         end

            `uvm_info(get_type_name(), $sformatf("master received data: %h", req.data_in), UVM_MEDIUM)
        
    endtask
endclass