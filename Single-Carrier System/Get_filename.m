
function [filename] = Get_filename(DE_option,td_window,sys_par,fade_struct,est_par,tx_par,rx_par,indv,dv)

% filename of .mat
filename = "";
filename = filename + "data/";

switch(DE_option.type)
    case(1)
        filename = filename + "E-mode";
    case(2)
        filename = filename + "D-mode";
    case(3)
        filename = filename + "D&E-mode";
end
switch(fade_struct.ch_model)
    case(3)
        filename = filename + "_No_Uni_ch";
    case(4)
        filename = filename + "_Uni_ch";
end

if(sys_par.equal_power==1)
    filename = filename + "_" + "Equalpower";
end

filename = filename + "_" + td_window.str(td_window.type);
filename = filename + "_" + sys_par.cpzp_type_str(sys_par.cpzp_type);
filename = filename + "_" + sys_par.ts_type_str(sys_par.ts_type);
if(td_window.type == 2)
    filename = filename + "_Q=" +num2str(td_window.Q);
end

if(DE_option.estimation_on == 1)
   filename = filename+"_"+est_par.BEM.window_str(est_par.BEM.window)+ est_par.BEM.str(est_par.BEM.type) + "_" + est_par.type_str(est_par.type);
end

if(DE_option.detection_on == 1)
    filename = filename + "_" + rx_par.type_str(rx_par.type);
    
    if(rx_par.type == 1||rx_par.type == 7)
        if(rx_par.IBDFE.first_iteration_full == 1)
            filename = filename + "_1st_full";
        end
    end
    if(rx_par.type == 5||rx_par.type == 6||rx_par.type == 7||rx_par.type == 8)
        filename = filename + "_D=" + num2str(rx_par.IBDFE.D);
    end
end

filename = filename + "_" + tx_par.mod_type_str(tx_par.mod_type);
filename = filename + "_fd=" + num2str(fade_struct.fd);
filename = filename + "_N=" + num2str(sys_par.tblock);
filename = filename + "_I=" + num2str(est_par.BEM.I);
filename = filename + "_M=" + num2str(sys_par.M);
filename = filename + "_Nblock=" + num2str(tx_par.nblock);
filename = filename + "_BW=" + num2str(sys_par.bandwidth_efficiency);
filename = filename + ".mat";