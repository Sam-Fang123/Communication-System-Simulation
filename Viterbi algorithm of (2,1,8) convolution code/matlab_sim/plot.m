
semilogy(SNR_db,BER_uncoded);
hold on
semilogy(SNR_db,BER_218_soft);
semilogy(SNR_db,BER_318_soft);
semilogy(SNR_db,BER_218);
semilogy(SNR_db,BER_318);

xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on