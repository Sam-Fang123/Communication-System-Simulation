clear
Eb=10;      % Bit energy = 10W
T=1;        % Bit duration = 1s;
bits_num=10^6;      % The number of bits
S0=(2*Eb*T)^(1/2)*ones(1,bits_num);       % Data bit=0
S1=-(2*Eb*T)^(1/2)*ones(1,bits_num);      % Data bit=1
SNR=[10^(1/10) 10^(3/10) 10];             % SNR = 1, 3, 10 dB
noise_pow=2*Eb*T./SNR;
w1=transpose((noise_pow).^(1/2))*randn(1,bits_num);     % Noise pdf
w2=transpose((noise_pow).^(1/2))*randn(1,bits_num);
r1=w1+S0;
r2=w2+S1;
for i=1:3
    subplot(3,1,i);
    histogram(r1(i,:));
    hold on
    histogram(r2(i,:));
    hold off
    title('SNR =',10*log10(SNR(i)));
end