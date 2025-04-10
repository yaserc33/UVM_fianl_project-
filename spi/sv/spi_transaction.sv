class spi_transaction extends uvm_sequence_item;
 
  rand bit [7:0] data_in;
  bit [7:0] data_out;


// Enable automation of the packet's fields
        `uvm_object_utils_begin(spi_transaction)
        `uvm_field_int(data_in, UVM_ALL_ON)
        `uvm_field_int(data_out, UVM_ALL_ON)
        `uvm_object_utils_end


  function new(string name = "spi_transaction");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("data_in", data_in, 8, UVM_HEX);
    printer.print_field("data_out", data_out, 8, UVM_HEX);

  endfunction
endclass : spi_transaction