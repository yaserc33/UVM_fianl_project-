class mc_seq extends uvm_sequence;
    
    `uvm_object_utils(mc_seq)
  
   //declare the multichannel_sequencer
    `uvm_declare_p_sequencer(mc_sequencer)


    function new(string name ="mc_seq");
        super.new(name);
    endfunction:new

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



endclass: mc_seq









class write_seq extends mc_seq;
    
    `uvm_object_utils(write_seq)
 

    function new(string name ="write_seq");
        super.new(name);
    endfunction:new


  // declare the sequences to run
  wb_read_seq wb_seq;
   wb_write_seq wb_seq_w;
    // wb_write_seq wb_seq;
  spi_slave_response_seq spi_seq;

  virtual task body();
    `uvm_info(get_type_name(), "Body of mc_seq 🧑🏻‍⚖️", UVM_FULL)

    // create sequence instances before starting
    wb_seq = wb_read_seq::type_id::create("wb_seq");
    wb_seq_w = wb_write_seq::type_id::create("wb_seq");
    // wb_seq = wb_write_seq::type_id::create("wb_seq");
    spi_seq = spi_slave_response_seq::type_id::create("spi_seq");
     
    wb_seq_w.start(p_sequencer.wb_seqr);
    fork
      wb_seq.start(p_sequencer.wb_seqr);
      spi_seq.start(p_sequencer.spi_seqr);
    join

  endtask : body





// //declare the sequences you want to use

// wb_write_seq wb_write;   // SEQUENCE: wb_write_seq -  write byte to spi peripheral (addr 2 spi data register) then dumy read from data reg to empty the read fifo of the spi

// //in task body() do the SEQs in the targeted seqr
// virtual task body;
// `uvm_info(get_type_name(), "body of mc_sequence 🧑🏻‍⚖️" , UVM_FULL)

// `uvm_do_on(wb_write, p_sequencer.wb_seqr)
// endtask:body


endclass: write_seq








class read_seq extends mc_seq;
    
    `uvm_object_utils(read_seq)
 

    function new(string name ="read_seq");
        super.new(name);
    endfunction:new

//declare the sequences you want to use


//in task body() do the SEQs in the targeted seqr
virtual task body;


//`uvm_do_on(wb_write, p_sequencer.wb_seqr)

endtask:body


endclass: read_seq