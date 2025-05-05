module hw_top;

  // Clock and Reset Signals
  logic clock;
  logic reset;
  logic sclk ;

clkgen clkgen (
     .clock(clock),
  .run_clock(1'b1),
    .clock_period(32'd10)
  );
  // Instantiate SPI Interface
  spi_if in0 (
    .clock(clock),
    .reset(reset),
    .sclk(sclk)
  );

  // Instantiate Simple SPI Module
  simple_spi spi_inst (
    .clk_i(clock),
    .rst_i(reset),
    .cyc_i(1'b1),  
    .stb_i(1'b1),
    .adr_i(3'b000),
    .we_i(1'b0),
    .dat_i(8'h00),
    .dat_o(),
    .ack_o(),
    .inta_o(),
    .sck_o(slck),      // Connect SCLK from spi_if
    .ss_o(in0.cs),         // Connect CS from spi_if
    .mosi_o(in0.mosi),     // Connect MOSI from spi_if
    .miso_i(in0.miso)      // Connect MISO from spi_if
  );



  

  // Reset Logic
  initial begin
    reset = 1'b1;
    #20 reset = 1'b0;  // Reset active for 20ns
  end

endmodule
