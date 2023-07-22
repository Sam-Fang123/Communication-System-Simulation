function [C B beta]=coeff_IBDFE_T2C1(sys_par,H_FD,signal_pwr,decision_pwr,noise_pwr,cor,coreff)

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
windowed_noise_cov = diag(noise_pwr*ones(1,sys_par.tblock));
K=(windowed_noise_cov/signal_pwr)+(1-coreff)*H_FD*(H_FD');
%L=sum(diag(H_FD'*inv(K)*H_FD),1);
%temp=1+coreff/sys_par.tblock*L;
%C=H_FD'*inv(K.*temp);
C = H_FD'/K;
%beta=L/(sys_par.tblock*temp);
beta = sum(diag(C*H_FD),1)/sys_par.tblock;
B=-cor/decision_pwr*(C*H_FD-beta*eye(sys_par.tblock));