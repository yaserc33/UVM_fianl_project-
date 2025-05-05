module hw_top;

// Clock and reset signals
logic [31:0]  clock_period;
logic         run_clock;
logic         clock;
logic         reset;
logic sclk1 ;
logic cs1 ;
logic sclk2 ;
logic cs2 ;

//interfaces

clock_and_reset_if cr_if (
              .clock(clock),
              .reset(reset),
              .run_clock(run_clock), 
              .clock_period(clock_period));



wb_if wif (
            .clk(clock),
            .rst_n(reset));


spi_if sif1 (
    .clock(clock),
    .reset(reset),
    .sclk(sclk1),
    .cs(cs1)
  );

spi_if sif2 (
    .clock(clock),
    .reset(reset),
    .sclk(sclk2),
    .cs(cs2)
  );






// CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );




wire [31:0] wb_m2s_dat_net;
wire [31:0] wb_s2m_dat_net;

assign wb_m2s_dat_net = {24'b0 , wif.din}; //our wb uvc support one byte data_in  for now
assign wb_s2m_dat_net= {24'b0 , wif.dout}; //our wb uvc support one byte data_out  for now



 wb_soc_top wb_top (

    .wb_clk(clock),
    .wb_rst(reset),
    .wb_m2s_adr(wif.addr),
    .wb_m2s_dat(wb_m2s_dat_net), 
    .wb_m2s_sel(), // our wb uvc doesn't support sel for now  
    .wb_m2s_we(wif.we),
    .wb_m2s_cyc(wif.cyc),
    .wb_m2s_stb(wif.stb),
    .wb_s2m_dat(wb_s2m_dat_net), 
    .wb_s2m_ack(wif.ack),
  
    // spi 1
    .o_spi_1_sclk(sclk1),     
    .o_spi_1_cs_n(cs1),     
    .o_spi_1_mosi(sif1.mosi),     
    .i_spi_1_miso(sif1.miso),     

    // spi 2
    .o_spi_2_sclk(sclk2),     
    .o_spi_2_cs_n(cs2),     
    .o_spi_2_mosi(sif2.mosi),     
    .i_spi_2_miso(sif2.miso),     

    // uart
    .o_uart_tx(),
    .i_uart_rx()
);















endmodule:hw_top