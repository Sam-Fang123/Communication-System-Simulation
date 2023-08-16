clear
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB_full_BPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv5=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB=2_BPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv4=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_Schniter_D=1_BPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_BPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TI_BPSK_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')

figure(1)
semilogy(indv.range,dv.BER_est(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-h');
semilogy(indv.range,dv4.BER_est(1,:),'->');
semilogy(indv.range,dv3.BER_est(10,:),'-o');
semilogy(indv.range,dv4.BER_est(3,:),'-s');
semilogy(indv.range,dv5.BER_est(3,:),'-d');
title('BPSK BER using Estimated CSI (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3]','Full-MMSE-LE, no windowing', ...
    'Banded-MMSE-LE Q=2 [5]',...
    'Schniter''s equalizer, 10th iteration, D=1',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration', ...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-7 1]);
xticks(indv.range)

figure(2)
semilogy(indv.range,dv.BER_ideal(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_ideal(1,:),'-h');
semilogy(indv.range,dv4.BER_ideal(1,:),'->');
semilogy(indv.range,dv3.BER_ideal(10,:),'-o');
semilogy(indv.range,dv4.BER_ideal(3,:),'-s');
semilogy(indv.range,dv5.BER_ideal(3,:),'-d');
title('BPSK BER using Perfect CSI (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3]','Full-MMSE-LE, no windowing', ...
    'Banded-MMSE-LE Q=2 [5]',...
    'Schniter''s equalizer, 10th iteration, D=1',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration', ...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-7 1]);
xticks(indv.range)

figure(3)
semilogy(indv.range,dv.BER_est(3,:),'-x');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-h');
semilogy(indv.range,dv4.BER_est(1,:),'->');
semilogy(indv.range,dv3.BER_est(10,:),'-o');
semilogy(indv.range,dv4.BER_est(3,:),'-s');
semilogy(indv.range,dv5.BER_est(3,:),'-d');

semilogy(indv.range,dv.BER_ideal(3,:),'--x');
semilogy(indv.range,dv2.BER_ideal(1,:),'--h');
semilogy(indv.range,dv4.BER_ideal(1,:),'-->');
semilogy(indv.range,dv3.BER_ideal(10,:),'--o');
semilogy(indv.range,dv4.BER_ideal(3,:),'--s');
semilogy(indv.range,dv5.BER_ideal(3,:),'--d');
title('BPSK BER (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1')
legend('IBDFE-TI(Tomasin), 3th iteration, no windowing [3](Est CSI)','Full-MMSE-LE, no windowing(Est CSI)', ...
    'Banded-MMSE-LE Q=2 [5](Est CSI)',...
    'Schniter''s equalizer, 10th iteration, D=1(Est CSI)',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration(Est CSI)', ...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration(Est CSI)',...
    'IBDFE-TI(Tomasin), 3th iteration, no windowing [3]','Full-MMSE-LE, no windowing', ...
    'Banded-MMSE-LE Q=2 [5]',...
    'Schniter''s equalizer, 10th iteration, D=1',...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration', ...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [5], 3th iteration')
xlim([0 indv.range(end)]);
ylim([10^-7 1]);
xticks(indv.range)

