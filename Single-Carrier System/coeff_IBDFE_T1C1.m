% 
%  ~ 2022/5/2
%  Scaling factor is removed

function [C B beta]=coeff_IBDFE_T1C1(sys_par,H_FD,signal_pwr,decision_pwr,noise_pwr,cor,coreff,w)

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
windowed_noise_cov = F*diag(w)*noise_pwr*diag(w')*F';
noise_pwr = windowed_noise_cov(1,1);

K=((noise_pwr/signal_pwr)+(1-coreff)*sum(abs(H_FD).^2,2)).';  % sum(, 2) = row sum
%temp=1+coreff/sys_par.tblock*sum(abs(diag(H_FD)).'.^2./K,2);
%C=diag( diag(H_FD)'./(K.*temp) ); % C is a diagonal matrix 
C=diag( diag(H_FD)'./ K ); % C is a diagonal matrix 
beta=sum(diag(C).*diag(H_FD),1)/sys_par.tblock;  % ok; sum(, 1) = column sum
B=-cor/decision_pwr*(C*H_FD-beta*eye(sys_par.tblock));

% % % print out beta for testing
% beta  % check if ~1
% 
% 
% % diag( ifft(B,sys_par.tblock)*fft(eye(sys_par.tblock),sys_par.tblock) )  % check if diag ~0 (not canceling the desired signal)
% 
% pause
