% pick the constellation table based on modulation type
% in the order of decimal 0,1,2,3,...,|C|
function[const_pt_table]=sc_gen_tables(tx_par)
 switch (tx_par.mod_type)
     case(1)  %% BPSK 
         const_pt_table = [-1 1];   % normalized BPSK constellation ,in the order of decimal 0,1
         
     case(2)  %% QPSK
          const_pt_table = [1+j 1-j -1+j -1-j]/sqrt(2);  % normalized QPSK constellation 
     
     case(3)  %% 16-QAM
          const_pt_table = [3+3*j 3+j 1+3*j 1+j ...  % in the order of decimal 0,1,2,3,...,15
               3-3*j 3-j 1-3*j 1-j ...
               -3+3*j -3+j -1+3*j -1+j ...
               -3-3*j -3-j -1-3*j -1-j]/sqrt(10);  
    
     case(4)  %% 64-QAM   
 
        % complex values
      real16 = [7 7 5 5 7 7 5 5 1 1 3 3 1 1 3 3]; % decimal values 0,1, ..., 15
      imag16 = [7 5 7 5 1 3 1 3 7 5 7 5 1 3 1 3]; % decimal values 0,1, ..., 15
      real64 = [real16 real16 -real16 -real16];  % decimal 0--63
      imag64 = [imag16 -imag16 imag16 -imag16];  % decimal 0--63
      const_pt_table = (real64 + j*imag64)/sqrt(42);      
      
 end
          