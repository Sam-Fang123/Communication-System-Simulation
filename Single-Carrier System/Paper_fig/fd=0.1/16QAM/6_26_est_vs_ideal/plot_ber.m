load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB_full_16QAM_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv3=dv;
load('D&E-mode_indv=SNR_Tang_ZP_Optiaml_GCE-BEM_MMSE_IBDFE_TV_1st_banded_Q=2_D_FF=1_D_FB=2_16QAM_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
dv2=dv;
load('D&E-mode_indv=SNR_No-windowing_ZP_Optiaml_GCE-BEM_MMSE_MMSE_FD_LE_full_16QAM_fd=0.1_N=256_I=5_M=5_Nblock=10000.mat')
figure(2)
semilogy(indv.range,dv.BER_est(1,:),'-o');
xlabel('SNR (dB)');
ylabel('average BER');
grid on;
hold on;
semilogy(indv.range,dv2.BER_est(1,:),'->');
semilogy(indv.range,dv2.BER_est(3,:),'-s');
semilogy(indv.range,dv3.BER_est(3,:),'-*');
semilogy(indv.range,dv.BER_ideal(1,:),'--o');
semilogy(indv.range,dv2.BER_ideal(1,:),'-->');
semilogy(indv.range,dv2.BER_ideal(3,:),'--s');
semilogy(indv.range,dv3.BER_ideal(3,:),'--*');
title('16QAM BER (Normalized Doppler Frequency = 0.1), IBDFE-TV D_F_F=1')
legend('Full-MMSE-LE, no windowing','Banded-MMSE-LE Q=2 [6]', ...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [6], 3th iteration',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [6], 3th iteration',...
    'Full-MMSE-LE, no windowing (Perfect CSI)','Banded-MMSE-LE Q=2 [6] (Perfect CSI)', ...
    'IBDFE-TV D_F_B=2, 1st iteration use Banded-MMSE-LE Q=2 [6], 3th iteration (Perfect CSI)',...
    'IBDFE-TV D_F_B is full, 1st iteration use Banded-MMSE-LE Q=2 [6], 3th iteration (Perfect CSI)')
xlim([0 indv.range(end)]);
ylim([10^-3 1]);
xticks(indv.range)