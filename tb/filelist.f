/////////inclouding the UVCs

+incdir+../wb/sv            # include directory for sv files 
../wb/sv/wb_pkg.sv          # compile YAPP package 
../wb/sv/wb_if.sv           # compile top level module 

+incdir+../clock_and_reset/sv 
../clock_and_reset/sv/clock_and_reset_if.sv
../clock_and_reset/sv/clock_and_reset_pkg.sv

+incdir+../spi/sv 
../spi/sv/spi_pkg.sv
../spi/sv/spi_if.sv



+incdir+../dut  
../dut/fifo4.v 
../dut/spi.v 
../dut/clkgen.sv
../dut/hw_top.sv



top.sv    # compile top level module 



////// run command
// vcs -sverilog -timescale=1ns/1ns -full64 -f filelist.f -ntb_opts -uvm   -o   simv ;     ./simv -f run.f;

