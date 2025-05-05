
// include directories, starting with UVM src directory
-incdir ../sv

// compile files
../sv/wb_pkg.sv
../sv/wb_if.sv 
demo_wb_top.sv




////// run command
// vcs -sverilog -timescale=1ns/1ns -full64 -f filelist.f -ntb_opts -uvm   -o   simv ;     ./simv -f run.f;

