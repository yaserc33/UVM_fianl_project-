class wb_x_spi_module extends uvm_component;
  `uvm_component_utils(wb_x_spi_module)

  // Registers
  logic [7:0] SPCR = 8'h10;  // Control Register
  logic [7:0] SPSR = 8'h05;  // Status Register
  logic [7:0] SPDR = 8'h00;  // Data Register
  logic [7:0] SPER = 8'h00;  // Extensions Register
  logic [7:0] CSREG = 8'h00; // Chip Select Register

  // Queues for tracking TX (WB) and RX (SPI) data
  bit [7:0] tx_queue[$]; // Data sent from WB to SPI
  bit [7:0] rx_queue[$]; // Data received from SPI UVC

  wb_transaction wb_queue[$];
  spi_transaction spi_queue[$]; 

  // Analysis port to send transactions to scoreboard
  uvm_analysis_port#(wb_transaction) ref_analysis_port;

  // Analysis implementation port to receive WB transactions from monitor
  `uvm_analysis_imp_decl(_wb)
  uvm_analysis_imp_wb#(wb_transaction, wb_x_spi_module) wb_in;

  function new(string name = "wb_x_spi_module", uvm_component parent);
    super.new(name, parent);
    ref_analysis_port = new("ref_analysis_port", this);
    wb_in = new("wb_in", this);
  endfunction

  function void write_wb(wb_transaction t);
    wb_transaction s;
    s = wb_transaction::type_id::create("s", this);

    s.addr = t.addr;
    s.op_type = t.op_type;
    s.valid_sb = t.valid_sb;

    if (t.op_type == wb_write) begin
      s.dout = t.dout;
      s.din  = t.din;

      case (t.addr)
        32'h0: SPCR = t.din;
        32'h1: SPSR = t.din;
        32'h2: SPDR = t.din;
        32'h3: SPER = t.din;
        32'h4: CSREG = t.din;
        default: ;
      endcase
    end else if (t.op_type == wb_read) begin
      s.din = t.din;
      case (t.addr)
        32'h0: s.dout = SPCR;
        32'h1: s.dout = SPSR;
        32'h2: s.dout = SPDR;
        32'h3: s.dout = SPER;
        32'h4: s.dout = CSREG;
        default: s.dout = 8'h00;
      endcase
    end

    ref_analysis_port.write(s);
  endfunction

  // Getter Functions
  function logic [7:0] get_SPCR();
    return SPCR;
  endfunction

  function logic [7:0] get_SPSR();
    return SPSR;
  endfunction

  function logic [7:0] get_SPER();
    return SPER;
  endfunction

  function logic [7:0] get_CSREG();
    return CSREG;
  endfunction

endclass
