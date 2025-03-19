
/*-----------------------------------------------
 IUS release without embedded UVM library,
 using library supplied with lab files.
------------------------------------------------*/
-uvmhome $UVMHOME

// include directories, starting with UVM src directory
-incdir ../sv

// uncomment for gui
//-gui
//+access+rwc

// default timescale
-timescale 1ns/100ps

// options
//+UVM_VERBOSITY=UVM_LOW
+UVM_VERBOSITY=UVM_HIGH
//+UVM_TESTNAME=demo_base_test

+UVM_TESTNAME=spi_read_test
//+UVM_TESTNAME=hbus_master_topology


