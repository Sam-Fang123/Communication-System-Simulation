
function [] = error_message(td_window,sys_par,fade_struct,tx_par,ts_par,rx_par,est_par)

if(sys_par.ts_type==2)  %Optimal
    if(ts_par.mod_type~=1)
        error('Optimal training should use BPSK pilot symbol');
    end
elseif(sys_par.ts_type==1)  %Non-Optimal
    if(tx_par.mod_type~=ts_par.mod_type)
        error('Non-optimal should use same modulation type');
    end
end

if(sys_par.ts_type==2&&est_par.type~=3)
    error('Optimal placement should use MMSE estimator')
end

if(rx_par.type==2||rx_par.type==3)  %IBDFE-TV or MMSE-FD-LE
    if(rx_par.IBDFE.first_iteration_banded==1)
        if(td_window.type==1)
            error('Banded-MMSE should use window')
        end
    else
        if(td_window.type~=1)
            error('Full-MMSE should not use window')
        end
    end
end

if(rx_par.type==1&&td_window.type~=1)
    error('IBDFE-TI should not use window')
end

if((rx_par.type==4||rx_par.type==5)&&td_window.type==1)
    error('Schniter Equalizer or Serial-LE should use window')
end

if(rx_par.type==5&&tx_par.mod_type~=1)
    error('Schniter Equalizer should use BPSK')
end

if(rx_par.IBDFE.D_FF_Full==1&&rx_par.IBDFE.D_FB_Full==0)
    error('We dont have Full FF Filter and Banded FB Filter IBDFE');
end

if(sys_par.ndata<=0)
    error('There is no data symbol in the transmitted block');
end



    

    
    