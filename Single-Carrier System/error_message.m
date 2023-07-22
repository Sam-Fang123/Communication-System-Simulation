
function [] = error_message(td_window,sys_par,fade_struct,tx_par,ts_par,rx_par)

if(sys_par.ts_type==2)  %Optimal
    if(ts_par.mod_type~=1)
        error('Optimal training should use BPSK pilot symbol');
    end
elseif(sys_par.ts_type==1)  %Non-Optimal
    if(tx_par.mod_type~=ts_par.mod_type)
        error('Non-optimal should use same modulation type');
    end
end

if(rx_par.IBDFE.first_iteration_banded==1)
    if(td_window.type==1)
        error('Banded-MMSE should use window')
    end
else
    if(td_window.type~=1)
        error('Full-MMSE should not use window')
    end
end

if(rx_par.type==1&&td_window.type~=1)
    error('IBDFE-TI should not use window')
end

if(rx_par.IBDFE.D_FF_Full==1&&rx_par.IBDFE.D_FB_Full==0)
    error('We dont have Full FF Filter and Banded FB Filter IBDFE');
end

    

    
    