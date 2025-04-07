class mc_seq extends uvm_sequence;
    
  `uvm_object_utils(mc_seq)

  // declare the multi-channel sequencer
  `uvm_declare_p_sequencer(mc_sequencer)

  function new(string name = "mc_seq");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Drop objection", UVM_MEDIUM)
    end
  endtask : post_body

  // declare the sequences to run
  wb_read_seq wb_seq;
    // wb_write_seq wb_seq;
  spi_slave_response_seq spi_seq;

  virtual task body();
    `uvm_info(get_type_name(), "Body of mc_seq 🧑🏻‍⚖️", UVM_FULL)

    // create sequence instances before starting
    wb_seq = wb_read_seq::type_id::create("wb_seq");
    // wb_seq = wb_write_seq::type_id::create("wb_seq");
    spi_seq = spi_slave_response_seq::type_id::create("spi_seq");

    fork
      wb_seq.start(p_sequencer.wb_seqr);
      spi_seq.start(p_sequencer.spi_seqr);
    join

  endtask : body

endclass : mc_seq
