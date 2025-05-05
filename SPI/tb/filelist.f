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
#      inclouding the rtl files
///////////////////////////////////////

+incdir+../rtl  

// SPI files
../rtl/spi/fifo4.v
../rtl/spi/simple_spi_top.v

// UART files
../rtl/uart/raminfr.v
../rtl/uart/uart_defines.v
../rtl/uart/uart_sync_flops.v
../rtl/uart/uart_rfifo.v
../rtl/uart/uart_tfifo.v
../rtl/uart/uart_receiver.v
../rtl/uart/uart_transmitter.v
../rtl/uart/uart_regs.v
../rtl/uart/uart_wb.v
../rtl/uart/uart_top.v

// Wishbone Interconnect files
../rtl/WishboneInterconnect/wb_mux.v
../rtl/WishboneInterconnect/wb_intercon.sv
../rtl/WishboneInterconnect/wb_soc_top.sv

+incdir+../wb_x_spi_module/sv
../wb_x_spi_module/sv/spi_module_pkg.sv

// clokgen & hw_top files
clkgen.sv
hw_top.sv


# compile top level module 
top.sv    




//     run command
// vcs -sverilog -timescale=1ns/1ns -full64 -f filelist.f -ntb_opts -uvm   -o   simv ;     ./simv -f run.f;

