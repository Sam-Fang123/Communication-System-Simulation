function [C B beta]=coeff_IBDFE_T3C1(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,D,w)

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
windowed_noise_cov = F*diag(w)*noise_pwr*diag(w')*F';

index_set = 1:sys_par.tblock;
t_set = index_set.'+(-D:D);
t_set = mod(t_set-1,sys_par.tblock)+1;
C = zeros(sys_par.tblock,sys_par.tblock);
temp1 = H*H'*(1-coreff);
beta = 0;
for ii = 1:sys_par.tblock
    K = temp1(t_set(ii,:),t_set(ii,:)) + windowed_noise_cov(t_set(ii,:),t_set(ii,:))/signal_pwr;
    C(ii,t_set(ii,:)) = H(t_set(ii,:),ii)'/K;
    beta = beta + C(ii,t_set(ii,:))*H(t_set(ii,:),ii);
end
beta = beta/sys_par.tblock;
B=-cor/decision_pwr*(C*H-beta*eye(sys_par.tblock));



%{
K=(noise_pwr/signal_pwr)*eye(sys_par.tblock)+(1-coreff)*H_FD*H_FD';
%L=sum(diag(H_FD'*inv(K)*H_FD),1);
%temp=1+coreff/sys_par.tblock*L;
%C=H_FD'*inv(K.*temp);
C = H_FD'/K;
%beta=L/(sys_par.tblock*temp);
beta = sum(diag(C*H_FD),1)/sys_par.tblock;
B=-cor/decision_pwr*(C*H_FD-beta*eye(sys_par.tblock));
%}