module hw_top;

// Clock and reset signals
logic [31:0]  clock_period;
logic         run_clock;
logic         clock;
logic         reset;

//interfaces

clock_and_reset_if cr_if (
              .clock(clock),
              .reset(reset),
              .run_clock(run_clock), 
              .clock_period(clock_period));



wb_if wif (
            .clk(clock),
            .rst_n(reset));


spi_if sif (
    .clock(clock),
    .reset(reset)
  );




// CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );




//SPI module
simple_spi#(.SS_WIDTH(1)) spi1( 
  // SS_WIDTH indcate how many slave for spi  master
  // 8bit WISHBONE bus slave interface
  .clk_i(clock),           // clock
  .rst_i(reset),           // reset (synchronous active high)
  .cyc_i(wif.cyc),         // cycle
  .stb_i(wif.stb),         // strobe
  .adr_i(wif.addr[2:0]),   // address
  .we_i(wif.we),          // write enable
  .dat_i(wif.din),         // data input
  .dat_o(wif.dout),         // data output
  .ack_o(wif.ack),         // normal bus termination
  .inta_o(wif.inta),        // interrupt output

  // SPI interface
  .sck_o(sif.sclk),         // serial clock output
  .ss_o(sif.cs),          // slave select (active low)
  .mosi_o(sif.mosi),        // MasterOut SlaveIN
  .miso_i(sif.miso)         // MasterIn SlaveOut

);













endmodule:hw_top
