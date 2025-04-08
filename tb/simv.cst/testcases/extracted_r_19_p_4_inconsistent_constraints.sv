class c_19_4;
    int valid_sb = 0;

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (../wb/sv/../sv/wb_master_seqs.sv:179)
    {
       (valid_sb == 1);
    }
endclass

program p_19_4;
    c_19_4 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "1zzz001zz0x0zz100xzzxxz1010zzz00xxzzxxzxzxzzxxzxxxxzzzzxzxxzxxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
