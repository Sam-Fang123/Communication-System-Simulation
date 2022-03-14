
clear all
bits_num=1024*10^3;         % # of bits
fft_size=64;          % fft size
input=rand(1,bits_num);
Eb=10;      %bits energy
in_bits(input>0.5)=Eb^(1/2);   % Eb is bit energy, so input bit is +-Eb^(1/2)
in_bits(input<=0.5)=-Eb^(1/2);
SNR=1:25;               % SNR 
noise_pow=Eb./SNR;    % SNR=Eb/N0, so N0=Eb/SNR     

BER=[];
for j=1:length(noise_pow)
    num_of_error=0;
    for i=0:fft_size:length(in_bits)-fft_size
        x(i+1:i+fft_size)=ifft(in_bits(i+1:i+fft_size),fft_size)*sqrt(fft_size);
    end
  
    r=x+sqrt(noise_pow(j))*randn(1,bits_num)+sqrt(-1)*sqrt(noise_pow(j))*randn(1,bits_num); 
    % Noise needs to be added to both real and imaginary part!!!
    
    for k=0:fft_size:length(in_bits)-fft_size
        X(k+1:k+fft_size)=fft(r(k+1:k+fft_size),fft_size)/(sqrt(fft_size));
    end
    
    out_bits(X>0)=Eb^(1/2);   
    out_bits(X<=0)=-Eb^(1/2); 
    BER(j)=sum(out_bits~=in_bits)/bits_num;
    r2=in_bits+sqrt(noise_pow(j))*randn(1,bits_num)+sqrt(-1)*sqrt(noise_pow(j))*randn(1,bits_num);
    out_bits2(r2>0)=Eb^(1/2);
    out_bits2(r2<=0)=-Eb^(1/2);
    BER2(j)=sum(out_bits2~=in_bits)/bits_num;
end
figure(2)
theoretical_BER=qfunc(SNR.^(1/2));  % Theoretical BER
semilogy(10*log10(SNR),BER,'LineWidth',1.3);
hold on
semilogy(10*log10(SNR),BER2,'LineWidth',1.3);
semilogy(10*log10(SNR),theoretical_BER,'LineWidth',1.3);
ylim([10^-5 1]);
title('BER curve(Equal probability)');
legend('OFDM BER','Without OFDM','T SNR');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
