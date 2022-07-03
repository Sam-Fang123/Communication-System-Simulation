
semilogy(SNR_db,BER_uncoded,'linewidth',1.5);
hold on
semilogy(SNR_db,BER_216_soft,'linewidth',1.5);
semilogy(SNR_db,BER_316_soft,'linewidth',1.5);
semilogy(SNR_db,BER_216,'linewidth',1.5);
semilogy(SNR_db,BER_316,'linewidth',1.5);
legend('uncoded','(2,1,6) soft','(3,1,6) soft','(2,1,6) hard','(3,1,6) hard')
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on