///////////////////////////////////////
#      inclouding the UVCs
///////////////////////////////////////
+incdir+../wb/sv            # include directory for sv files 
../wb/sv/wb_pkg.sv          # compile YAPP package 
../wb/sv/wb_if.sv           # compile top level module 

+incdir+../clock_and_reset/sv 
../clock_and_reset/sv/clock_and_reset_if.sv
../clock_and_reset/sv/clock_and_reset_pkg.sv

+incdir+../spi/sv 
../spi/sv/spi_pkg.sv
../spi/sv/spi_if.sv




///////////////////////////////////////
#      inclouding the dut files
///////////////////////////////////////

+incdir+../dut  

// SPI files
../dut/spi/fifo4.v
../dut/spi/simple_spi_top.v

// UART files
../dut/uart/raminfr.v
../dut/uart/uart_defines.v
../dut/uart/uart_sync_flops.v
../dut/uart/uart_rfifo.v
../dut/uart/uart_tfifo.v
../dut/uart/uart_receiver.v
../dut/uart/uart_transmitter.v
../dut/uart/uart_regs.v
../dut/uart/uart_wb.v
../dut/uart/uart_top.v

// Wishbone Interconnect files
../dut/WishboneInterconnect/wb_mux.v
../dut/WishboneInterconnect/wb_intercon.sv
../dut/WishboneInterconnect/wb_soc_top.sv

// clokgen & hw_top files
../dut/clkgen.sv
../dut/hw_top.sv


# compile top level module 
top.sv    




//     run command
// vcs -sverilog -timescale=1ns/1ns -full64 -f filelist.f -ntb_opts -uvm   -o   simv ;     ./simv -f run.f;

