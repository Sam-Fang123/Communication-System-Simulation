
function [w]=Iter_SC_window(sys_par,rx_par,fade_struct,snr,Q)

F = dftmtx(sys_par.tblock)/sqrt(sys_par.tblock);


