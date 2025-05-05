class c_23_3;
    rand bit[0:0] valid_sb; // rand_mode = ON 

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (../wb/sv/../sv/wb_master_seqs.sv:124)
    {
       (valid_sb == 2);
    }
endclass

program p_23_3;
    c_23_3 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0zzxxzxz100xx0zxxxxzzxx111z010zzxzzzzzzzxzxxzzzxxxxxzzxxxxxxzzzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
