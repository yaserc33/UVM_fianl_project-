
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
// SEQUENCE: wb_write_spi1_seq -  write byte to spi1 peripheral (addr 2 spi data register) then dumy read from data reg to empty the read fifo of the spi
//------------------------------------------------------------------------------

class enable_spi_core  extends wb_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(enable_spi_core)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    
    
    `uvm_do_with(req,
                 { op_type == wb_write ; // we =1
                   addr == 0; // enable spi by setting the control register 
                   din==8'b01110000;  // 7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
                   valid_sb==0;// indecate write sequnnace

                   })

       
    `uvm_do_with(req,
                 { op_type == wb_write ; 
                   addr == 4;        //manually control CS singal through  register 4
                   din==8'b0000001;  // [0]:  1 to clear Cs     0 to set cs
                   valid_sb==0;// indecate write sequnnace

                   })

    

      #160;      //stalling until spi send out the byte serially on mosi   
   
`uvm_do_with(req, 
                    { op_type == wb_write ; 
                      addr == 4; //manually control CS singal through  register 4
                      din==8'b0000000;  // [0]:  1 to clear Cs     0 to set cs
                      valid_sb==0;// indecate read sequnnace
                      })


 `uvm_do_with(req,
                 { op_type == wb_read ;
                   addr == 0;
                   din==8'b00110000; 
                   valid_sb==0;// indecate write sequnnace
                   } //sending read requist to data reg to empty the garbge from read fifo
                )
   
  
   
  
   
   

//    `uvm_info(get_type_name(), $sformatf("wb WRITE ADDRESS:%0d  DATA:%h", req.addr, req.din), UVM_MEDIUM)

  endtask : body


endclass : enable_spi_core

//------------------------------------------------------------------------------
// SEQUENCE: wb_write_spi1_seq -  write byte to spi1 peripheral (addr 2 spi data register) then dumy read from data reg to empty the read fifo of the spi
//------------------------------------------------------------------------------

class wb_write_spi1_seq extends wb_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_write_spi1_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    
    
    `uvm_do_with(req,
                 { op_type == wb_write ; // we =1
                   addr == 0; // enable spi by setting the control register 
                   din==8'b01110000;  // 7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
                   valid_sb==0;// indecate write sequnnace

                   })

       
    `uvm_do_with(req,
                 { op_type == wb_write ; 
                   addr == 4;        //manually control CS singal through  register 4
                   din==8'b0000001;  // [0]:  1 to clear Cs     0 to set cs
                   valid_sb==0;// indecate write sequnnace

                   })

      //  `uvm_do_with(req,
      //            { op_type == wb_write ; 
      //              addr == 2;        //manually control CS singal through  register 4
      //              din==8'b0000001;  // [0]:  1 to clear Cs     0 to set cs
      //              valid_sb==0;// indecate write sequnnace

      //              }) 
    `uvm_do_with(req,
                 { op_type == wb_write ; // write a random data to data register 
                   addr == 4;
                    din==8'b01110000; 
                   valid_sb==1;// indecate write sequnnace

                   }
                )
   

      #160;      //stalling until spi send out the byte serially on mosi   
   
`uvm_do_with(req, 
                    { op_type == wb_write ; 
                      addr == 4; //manually control CS singal through  register 4
                      din==8'b0000000;  // [0]:  1 to clear Cs     0 to set cs
                      valid_sb==0;// indecate read sequnnace
                      })


 `uvm_do_with(req,
                 { op_type == wb_read ;
                   addr == 1;
                   din==8'b00110000; 
                   valid_sb==0;// indecate write sequnnace
                   } //sending read requist to data reg to empty the garbge from read fifo
                )
   
  
   
   

//    `uvm_info(get_type_name(), $sformatf("wb WRITE ADDRESS:%0d  DATA:%h", req.addr, req.din), UVM_MEDIUM)

  endtask : body


endclass : wb_write_spi1_seq
//------------------------------------------------------------------------------
// SEQUENCE: wb_write_spi1_seq -  write byte to spi1 peripheral (addr 2 spi data register) then dumy read from data reg to empty the read fifo of the spi
//------------------------------------------------------------------------------



class wb_write_spi2_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_write_spi2_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
                 { op_type == wb_write;
                   addr == 16'h10; //SPI_2 control register base
                   din == 8'b01110000; // 7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
                   valid_sb == 0; //indecate write sequnnace
                 })

    `uvm_do_with(req,
                 { op_type == wb_write;
                   addr == 16'h14; //SPI_2 CS control register
                   din == 8'b00000001; // [0]:  1 to clear Cs     0 to set cs
                   valid_sb == 0; //indecate write sequnnace
                 })

    `uvm_do_with(req,
                 { op_type == wb_write;
                   addr == 16'h12; //SPI_2 data register
                   din == 8'b00011111; //dummy data 
                   valid_sb == 1; //indecate write sequnnace
                 })

    #160;


    `uvm_do_with(req,
                 { op_type == wb_write;
                   addr == 16'h14; //SPI_2 CS control register
                   din == 8'b00000000; // [0]:  1 to clear Cs     0 to set cs
                   valid_sb == 0; //indecate write sequnnace
                 })

    `uvm_do_with(req,
                 { op_type == wb_read;
                   addr == 16'h12; 
                   valid_sb == 0; //indecate write sequnnace
                 })

  endtask : body

endclass : wb_write_spi2_seq




//------------------------------------------------------------------------------
// SEQUENCE: wb_read_spi1_seq -  sendying  a dumy write then  send read byte read from spi1 peripheral (addr 3)
//------------------------------------------------------------------------------
class wb_read_spi1_seq extends wb_base_seq;

      function new(string name = get_type_name());
        super.new(name);
      endfunction

      `uvm_object_utils(wb_read_spi1_seq)

      virtual task body();
        `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

        `uvm_do_with(req,
                    { op_type == wb_write ; // we =1
                      addr == 0; // enable spi by setting the control register 
                      din==8'b01110000;  // 7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
                     valid_sb==0;// indecate read sequnnace
                      })



        `uvm_do_with(req,
                    { op_type == wb_write ; 
                      addr == 4;        //manually control CS singal through  register 4
                      din==8'b0000001;  // [0]:  1 to clear Cs     0 to set cs
                      valid_sb==0;// indecate read sequnnace
                      })



            `uvm_do_with(req,
                    { op_type == wb_write ; // damy write to data register 
                      addr == 2;
                      din==8'b000000;
                      valid_sb==0;// indecate read sequnnace
                      })

        #160;  //stalling until spi send out the byte serially on mosi   

        `uvm_do_with(req, 
                    { op_type == wb_write ; 
                      addr == 4; //manually control CS singal through  register 4
                      din==8'b0000000;  // [0]:  1 to clear Cs     0 to set cs
                      valid_sb==0;// indecate read sequnnace
                      })




        `uvm_do_with(req,
                    { op_type == wb_read ;
                      addr == 2;
                      din==8'b00000111;
                      valid_sb==1;// indecate read sequnnace
                      } //read requist to collect the data from spi read fifo
    )


  endtask : body


endclass : wb_read_spi1_seq



//------------------------------------------------------------------------------
// SEQUENCE: wb_read_spi1_seq -  sendying  a dumy write then  send read byte read from spi1 peripheral (addr 3)
//------------------------------------------------------------------------------

class wb_read_spi2_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_read_spi2_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    //enable SPI control register
    `uvm_do_with(req,
                 { op_type == wb_write ; 
                   addr == 16; //SPI_2 control register
                   din == 8'b01110000;  //7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
                   valid_sb == 0;  //indicate that it's a read sequence
                 })

    //control CS signal
    `uvm_do_with(req,
                 { op_type == wb_write ; 
                   addr == 20;  //SPI_2 Chip Select register
                   din == 8'b0000001;  //[0]:  1 to clear Cs     0 to set cs
                   valid_sb == 0; //indicate read sequence
                 })

    //to clear FIFO
    `uvm_do_with(req,
                 { op_type == wb_write ; 
                   addr == 18; //SPI_2 data register
                   din == 8'b000000;
                   valid_sb == 0; //indicate read sequence
                 })

    #160; 

    //disable CS signal
    `uvm_do_with(req,
                 { op_type == wb_write ; 
                   addr == 20;  //SPI_2 Chip Select register
                   din == 8'b0000000;  // [0]:  1 to clear Cs     0 to set cs
                   valid_sb == 0;  //indicate read sequence
                 })

    //read data from SPI_2 data register
    `uvm_do_with(req,
                 { op_type == wb_read ;
                   addr == 18;  // SPI_2 data register
                   valid_sb == 1; //indicate read sequence
                 })
  endtask : body

endclass : wb_read_spi2_seq





