class spi_module extends uvm_env;
  `uvm_component_utils(spi_module)

  // Declare components
  wb_x_spi_module sref_model;
  scoreboard myscoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Instantiate components
    sref_model = wb_x_spi_module::type_id::create("sref_model", this);
    myscoreboard = scoreboard::type_id::create("myscoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect analysis ports
    // sref_model.ref_analysis_port.connect(myscoreboard.ref_in);

    // Pass reference model handle to scoreboard for function calls
    myscoreboard.ref_model = sref_model;
  endfunction

endclass