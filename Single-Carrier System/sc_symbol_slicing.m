% z: decision variable
% hc: cursor channel coefficient
function [sym_det_dec sym_det_const]= sc_symbol_slicing(z,tx_par,power)

    [const_table] = sc_gen_tables(tx_par);
    eu_dist = abs(z/sqrt(power)-const_table);
    [dmin,idx_md]=min(eu_dist);
    sym_det_dec=idx_md-1;
    sym_det_const=const_table(idx_md);
