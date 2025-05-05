//time scale 
-timescale=1ns/1ps 

// include directories
-incdir ../sv # include directory for sv files
../sv/spi_pkg.sv # compile YAPP package
../sv/spi_if.sv # compile YAPP interface

// compile files
//*** add compile files here
../tb/fifo4.v 
../tb/simple_spi_top.v
../tb/clkgen.sv 
../tb/hw_top_dut.sv

tb_top.sv # compile top level module
