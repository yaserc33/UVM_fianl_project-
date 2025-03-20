
class wb_base_seq extends uvm_sequence #(wb_transaction);

  // Required macro for sequences automation
  `uvm_object_utils(wb_base_seq)

  string phase_name;
  uvm_phase phaseh;

  // Constructor
  function new(string name = "wb_base_seq");
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

endclass : wb_base_seq





//------------------------------------------------------------------------------
// SEQUENCE: wb_write_read_seq -  write byte to spi peripheral (addr 2 spi data register) then dumy read from data reg to empty the read fifo of the spi
//------------------------------------------------------------------------------

class wb_write_seq extends wb_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_write_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    
    
    `uvm_do_with(req,
                 { op_type == wb_write ; // we =1
                   addr == 0; //control register
                   din==8'b01110000;  // 7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
                   })

                       
  


   
   
   
   
    `uvm_do_with(req,
                 { op_type == wb_write ;
                   addr == 2;}
                )

      #160;         
    `uvm_do_with(req,
                 { op_type == wb_read ;
                   addr == 2;}
                )

  `uvm_do_with(req,
                 { op_type == wb_write ;
                   addr == 2;}
                )

      #160;         
  `uvm_do_with(req,
                 { op_type == wb_read ;
                   addr == 2;}
                )
   
   

//    `uvm_info(get_type_name(), $sformatf("wb WRITE ADDRESS:%0d  DATA:%h", req.addr, req.din), UVM_MEDIUM)

  endtask : body


endclass : wb_write_seq



//------------------------------------------------------------------------------
// SEQUENCE: wb_read__seq -  sendying  a dumy write then  send read byte read from spi peripheral (addr 3)
//------------------------------------------------------------------------------
class wb_read_seq extends wb_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_read_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

      
     `uvm_do_with(req,
                  { op_type == wb_write ;
                   addr == 2;}
                )
     `uvm_do_with(req,
                  { op_type == wb_read ;
                   addr == 2;}
                )


  endtask : body


endclass : wb_read_seq



//------------------------------------------------------------------------------
// SEQUENCE: wb_polling_seq -  the master will read continuously the stuts rgister of the spi if the spi fifo is not empty then cpu will send a read requist
//------------------------------------------------------------------------------
class wb_polling_seq extends wb_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_polling_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

     // while (true)begin
             `uvm_do_with(req,
                  { op_type == wb_read ;  addr == 1;})


           // if ()
        //    breake;
    //  end
        
            // rsp.print();

      // `uvm_do_with(req,
      //             { op_type == wb_read ;  addr == 2;})





  endtask : body


endclass : wb_polling_seq


//------------------------------------------------------------------------------
// SEQUENCE: wb_all_address_seq -  do random transacrtion (read or wirte) to all the address
//------------------------------------------------------------------------------
class wb_all_address_seq extends wb_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_all_address_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)


for (int i=0; i<255; ++i) 
    `uvm_do_with(req,{ addr == i;})
                
  




  endtask : body


endclass : wb_all_address_seq