%%  Assumption on data
clear all
bits_num = 64*10^5;    % # of bits
input = rand(1,bits_num)>0.5;     
X = input*2-1;       % X:Input bits


%% Channel assumption
h = [1 -0.5];          % Multipath channel impulse response
OFDM_symbol_power = 1;
SNR_db = 1:14;
SNR = 10.^(SNR_db/10);            % SNR = symbol power/(noise power on each part)
noise_pow = OFDM_symbol_power./(SNR);  % noise power = 1/(SNR)
BER=zeros(14);
for j=1:length(SNR)
    error_num = 0;
    for i=1:64:64*10^5
        r=conv(X(i:i+63),h);
        r=r(1:64)+sqrt(noise_pow(j))*randn(1,64);
        output(r>0)=1;
        output(r<0)=-1;
        error_num=error_num+sum(output~=X(i:i+63));
    end
    BER_bpsk(j)=error_num/bits_num;
end
semilogy(SNR_db,BER_bpsk,'-*');
hold on 
%legend('BPSK without OFDM','BPSK with OFDM');
title('BER curve in multipath');
xlabel('SNR(dB)');ylabel('BER');
ylim([10^-4 1]);
grid minor
grid on
        
