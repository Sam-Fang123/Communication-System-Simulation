clear
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=1_D_FF=0_D_FB_full_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=1_D_FF=0_D_FB=0_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_16QAM_fd=0.02_N=256_I=3_M=5_Nblock=10000.mat')
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'->');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'-*');
semilogy(indv.range,dv2.BER_est(3,:),'-o');
semilogy(indv.range,dv3.BER_est(3,:),'-d');
semilogy(indv.range,dv.BER_ideal(1,:),'-->');
semilogy(indv.range,dv2.BER_ideal(1,:),'--*');
semilogy(indv.range,dv2.BER_ideal(3,:),'--o');
semilogy(indv.range,dv3.BER_ideal(3,:),'--d');
title('16QAM BER (Normalized Doppler Frequency = 0.02), IBDFE-TV D_F_F=0')
legend('Full-MMSE-LE, no windowing','Banded-MMSE-LE Q=1 [6]', ...
    'IBDFE-TV D_F_B=0, 1st iteration use Banded-MMSE-LE Q=1 [6], 3th iteration',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=1 [6], 3th iteration',...
    'Full-MMSE-LE, no windowing (Perfect CSI)','Banded-MMSE-LE Q=1 [6] (Perfect CSI)', ...
    'IBDFE-TV D_F_B=0, 1st iteration use Banded-MMSE-LE Q=1 [6], 3th iteration (Perfect CSI)',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=1 [6], 3th iteration (Perfect CSI)')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)