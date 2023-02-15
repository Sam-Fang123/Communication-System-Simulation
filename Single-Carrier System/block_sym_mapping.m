function[const_sym dec_sym bit_sym]=block_sym_mapping(number,tx_par,ts_par,type)

persistent const_table; % normalized complex-valued constellation table
persistent const_table2;
persistent first_time;

%%% generate the constellation table for the specified modulation format
% the first time into this function
if isempty(first_time)
  first_time=1;
  
  % generate constellation table which contains the complex-valued symbols
  % of the speficied modulation format
  [const_table] = sc_gen_tables(tx_par); % already normalized 
  [const_table2] = sc_gen_tables(ts_par);
end %

switch(type)
    case(1) % Data symbol

        dec_sym=floor(rand(1,number)*tx_par.pts_mod_const); %% decimal value(ex,0:|c|-1)

        const_sym=const_table(dec_sym+1); % +1 for Matlab index   

        % now convert to bit block sym
        bit_sym = zeros(1,number*tx_par.nbits_per_sym);  
        for ii=1:number
            bit_sym( (ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(dec_sym(ii),2,tx_par.nbits_per_sym);
        end
    case(2) % Pilot symbol
        
        dec_sym=floor(rand(1,number)*ts_par.pts_mod_const); %% decimal value(ex,0:|c|-1)

        const_sym=const_table2(dec_sym+1); % +1 for Matlab index   

        % now convert to bit block sym
        bit_sym = zeros(1,number*ts_par.nbits_per_sym);  
        for ii=1:number
            bit_sym( (ii-1)*ts_par.nbits_per_sym+1:ii*ts_par.nbits_per_sym ) = my_dec2base(dec_sym(ii),2,ts_par.nbits_per_sym);
        end
end