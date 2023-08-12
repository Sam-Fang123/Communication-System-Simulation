
function [filename, filename2] = Get_filename(DE_option,td_window,sys_par,fade_struct,est_par,tx_par,rx_par,indv,dv,snr)

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

if(sys_par.equal_power==1)
    filename = filename + "_" + "Equalpower";
end


filename = filename + "_indv=" + indv.str(indv.option);
filename = filename + "_" + td_window.str(td_window.type);
filename = filename + "_" + sys_par.cpzp_type_str(sys_par.cpzp_type);
filename = filename + "_" + sys_par.ts_type_str(sys_par.ts_type);


if(DE_option.estimation_on == 1)
   filename = filename+"_"+ est_par.BEM.str(est_par.BEM.type) + "_" + est_par.type_str(est_par.type);
end

if(DE_option.detection_on == 1)
    filename = filename + "_" + rx_par.type_str(rx_par.type);
    
    if(rx_par.type==3)
        if(rx_par.IBDFE.first_iteration_banded==1)
            filename = filename + "_banded_Q="+ num2str(rx_par.IBDFE.frist_banded_Q);
        else
            filename = filename + "_full";
        end
    end
    
    if(rx_par.type==2)
        if(rx_par.IBDFE.first_iteration_banded==1)
            filename = filename + "_1st_banded_Q="+ num2str(rx_par.IBDFE.frist_banded_Q);
        else
            filename = filename + "_1st_full";
        end
        if(rx_par.IBDFE.D_FF_Full==1)
            filename = filename + "_D_FF_full";
        else
            filename = filename + "_D_FF=" + num2str(rx_par.IBDFE.D_FF);
        end
        if(rx_par.IBDFE.D_FB_Full==1)
            filename = filename + "_D_FB_full";
        else
            filename = filename + "_D_FB=" + num2str(rx_par.IBDFE.D_FB);
        end   
    end
    if(rx_par.type==4||rx_par.type==5)
        filename = filename + "_D="+ num2str(rx_par.IBDFE.frist_banded_Q);
    end
end

filename = filename + "_" + tx_par.mod_type_str(tx_par.mod_type);

if(indv.option==1)
    filename = filename + "_fd=" + num2str(fade_struct.fd);
elseif(indv.option==2)
    filename = filename + "_SNR=" + num2str(snr.db)+"dB";
end

filename = filename + "_N=" + num2str(sys_par.tblock);
filename = filename + "_I=" + num2str(est_par.BEM.I);
filename = filename + "_M=" + num2str(sys_par.M);
filename = filename + "_Nblock=" + num2str(tx_par.nblock);
%filename = filename + "_BW=" + num2str(sys_par.bandwidth_efficiency);
filename = filename + ".mat";

filename2 = "";

switch(rx_par.type)  
        case(1) %IBDFE_TI
            filename2=filename2+"IBDFE TI using ";
        case(2)
            filename2=filename2+"IBDFE TV using ";
        case(3)
            if(rx_par.IBDFE.first_iteration_banded~=1)
                filename2=filename2+"MMSE-FD-LE using ";
            else
                filename2=filename2+"Banded MMSE-FD-LE using ";
            end
        case(4)
            filename2=filename2+"Serial-LE using ";
        case(5)
            filename2=filename2+"Schniter Equalizer using ";
end

filename2 = filename2 + tx_par.mod_type_str(tx_par.mod_type) + ", ";
if(rx_par.type==1||rx_par.type==2)
    filename2 = filename2 + num2str(rx_par.iteration) + "th iteration, ";
end
filename2 = filename2 + "fd="+num2str(fade_struct.fd);
if(rx_par.type~=4||rx_par.type~=5)
    if(rx_par.IBDFE.first_iteration_banded==1)
        filename2 = filename2 + " Q=" + num2str(rx_par.IBDFE.frist_banded_Q);
    else
        filename2 = filename2 + " 1st full";
    end
else
    filename2 = filename2 + " D=" + num2str(rx_par.IBDFE.frist_banded_Q);
end

if(rx_par.type==1||rx_par.type==2)
    if(rx_par.IBDFE.D_FF_Full==1)
            filename2 = filename2 + " D_F_F full";
        else
            filename2 = filename2 + " D_F_F=" + num2str(rx_par.IBDFE.D_FF);
    end
    if(rx_par.IBDFE.D_FB_Full==1)
            filename2 = filename2 + " D_F_B full";
        else
            filename2 = filename2 + " D_F_B=" + num2str(rx_par.IBDFE.D_FB);
    end
end

