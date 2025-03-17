

//------------------------------------------------------------------------------
//
// wb transaction enums, parameters, and events
//
//------------------------------------------------------------------------------




//------------------------------------------------------------------------------
//
// CLASS: wb_transaction
//
//------------------------------------------------------------------------------

class wb_transaction extends uvm_sequence_item;     

  
  
typedef enum [1:0] bit { wb_read, wb_write , wb_ideal } op_type_enum; //from master POV 
rand op_type_enum op_type;
rand logic [31:0] addr;
rand logic [7:0] payload [];
rand bit [5:0] length;

 

//////////////////////
rand logic [7:0] din ;
rand logic [7:0] dout ;
/////////////////////




  `uvm_object_utils_begin(wb_transaction)
    `uvm_field_enum(op_type_enum, op_type, UVM_DEFAULT)
    `uvm_field_int(length, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_int(reg_addr, UVM_DEFAULT | UVM_DEC)
    `uvm_field_array_int(payload, UVM_DEFAULT)
    `uvm_object_utils_end


  constraint payload_length { length > 0; length == payload.size(); }
  constraint addr_limit {addr >= 0;  addr <= 'hff;  }
  



  function new (string name = "wb_transaction");
    super.new(name);
  endfunction : new



  function void post_randomize();

  if (op_type == "wb_read") begin 
    addr = 32'bx;
  end
  reg_addr = addr[1:0];
  endfunction :post_randomize




endclass : wb_transaction

