function [C B beta]=coeff_IBDFE_T4C1(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,D_FF,D_FB)


windowed_noise_cov = diag(noise_pwr*ones(1,sys_par.tblock));

index_set = 1:sys_par.tblock;
t_set = index_set.'+(-D_FF:D_FF);
t_set = mod(t_set-1,sys_par.tblock)+1;
t_set2 = index_set.'+(-D_FB:D_FB);
t_set2 = mod(t_set2-1,sys_par.tblock)+1;

C = zeros(sys_par.tblock,sys_par.tblock);
B = zeros(sys_par.tblock,sys_par.tblock);
beta = 0;
e = [zeros(1,D_FB) 1 zeros(1,D_FB)];
for ii = 1:sys_par.tblock
    K = H(t_set(ii,:),:)*H(t_set(ii,:),:)'-coreff*H(t_set(ii,:),t_set2(ii,:))*H(t_set(ii,:),t_set2(ii,:))'+ windowed_noise_cov(t_set(ii,:),t_set(ii,:))/signal_pwr;
    C(ii,t_set(ii,:)) = H(t_set(ii,:),ii)'/K;
    beta = beta + C(ii,t_set(ii,:))*H(t_set(ii,:),ii);
end
beta = beta/sys_par.tblock;
for ii = 1:sys_par.tblock
    B(ii,t_set2(ii,:)) = -cor/decision_pwr*(C(ii,t_set(ii,:))*H(t_set(ii,:),t_set2(ii,:))-beta*e);
end
    
    