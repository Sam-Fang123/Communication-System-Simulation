clear
bits_num=10^7;      % The number of bits
input=rand(1,bits_num);     
Eb=10;      % Bit energy = 10W
T=1;        % Bit duration = 1s;
P0=1/2;     % P[m0]=1/2, P[m1]=1-P[m0]=1/2
S0=(2*Eb*T)^(1/2);       % Bit=0
S1=-(2*Eb*T)^(1/2);      % Bit=1
in_bits(input<P0)=S0;    % Bits sequence ( Transmitted signal )
in_bits(input>=P0)=S1;   
SNR=1:25;           
noise_pow=2*Eb*T./SNR;      % SNR = 2*Eb*T / noise power
ML_threshold=(S0+S1)/2;     % Decision threshold (ML)

BER=[];
for j=1:size(noise_pow,2)  
    error=0;
    for k=1:10
        w=(noise_pow(j))^(1/2)*randn(1,bits_num);    % w's pdf
        r=in_bits+w;        % r:Received signal
        out_bits(r>ML_threshold)=1;     % r>threshold, output bits=0
        out_bits(r<=ML_threshold)=-1;   % r<threshold, output bits=1
        error=error+size(out_bits(out_bits*(2*Eb*T)^(1/2)~=in_bits),2);
    end
    BER(j)=error/(bits_num*10);
end
    

theoretical_BER=qfunc(SNR.^(1/2));  % Theoretical BER
approx_BER1=exp(-(SNR)/2)./(sqrt(2*pi*SNR));    %approximate BER1
approx_BER2=(1/2)*exp(-(SNR)/2);                %approximate BER2
semilogy(10*log10(SNR),approx_BER1,'g',10*log10(SNR),approx_BER2,'y','LineWidth',1.3);
hold on
semilogy(10*log10(SNR),theoretical_BER,'k',10*log10(SNR),BER,'b','LineWidth',1.3);
hold off
legend('approximate1','approximate2','theoretical','simulated');
title('BER curve(Equal probability)');
xlabel('SNR(dB)');ylabel('BER');
ylim([10^-5 1]);
grid minor
grid on
