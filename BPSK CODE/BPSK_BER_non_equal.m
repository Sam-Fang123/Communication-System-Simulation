clear
bits_num=10^6;      % The number of bits
input=rand(1,bits_num);     
Eb=10;      % Bit energy = 10W
T=1;        % Bit duration = 1s;
P0=0.85;     % P[m0]=0.85, P[m1]=1-P[m0]=0.15
S0=(2*Eb*T)^(1/2);       % Data bit=0
S1=-(2*Eb*T)^(1/2);      % Data bit=1
in_bits(input<P0)=S0;    % Bits sequence ( Transmitted signal )
in_bits(input>=P0)=S1;   
SNR=1:25;           
noise_pow=2*Eb*T./SNR;      % SNR = 2*Eb*T / noise power
ML_threshold=(S0+S1)/2;     % Decision threshold (ML)
MAP_threshold=(S0+S1)/2+noise_pow*log((1-P0)/P0)./(S0-S1);  % Decision threshold (MAP)
BER_ML=[];
BER_MAP=[];
for j=1:size(noise_pow,2)  
    error1=0;
    error2=0;
    for k=1:10
        w=(noise_pow(j))^(1/2)*randn(1,bits_num);    % w's pdf
        r=in_bits+w;        % r:Received signal
        out_bits_ML(r>ML_threshold)=1;     % r>threshold, output bits=0 (ML)
        out_bits_ML(r<=ML_threshold)=-1;   % r<threshold, output bits=1 (ML)
        error1=error1+size(out_bits_ML(out_bits_ML*(2*Eb*T)^(1/2)~=in_bits),2);
    
        out_bits_MAP(r>MAP_threshold(j))=1;     % r>threshold, output bits=0 (MAP)
        out_bits_MAP(r<=MAP_threshold(j))=-1;   % r<threshold, output bits=1 (MAP)
        error2=error2+size(out_bits_MAP(out_bits_MAP*(2*Eb*T)^(1/2)~=in_bits),2);
    end
    BER_ML(j)=error1/(bits_num*10);
    BER_MAP(j)=error2/(bits_num*10);
end
A=(S0-MAP_threshold)./sqrt(noise_pow);
B=(MAP_threshold-S1)./sqrt(noise_pow);

theoretical_BER=P0*qfunc(A)+(1-P0)*qfunc(B); % Theoretical BER
%approx_BER1=P0*exp(-(A.^2)/2)./(sqrt(2*pi*A.^2))+(1-P0)*exp(-(B.^2)/2)./(sqrt(2*pi*B.^2));    %approximate BER
%approx_BER2=P0*(1/2)*exp(-(A.^2)/2)+(1-P0)*exp(-(B.^2)/2);

%semilogy(10*log10(SNR),approx_BER1,'g',10*log10(SNR),approx_BER2,'y','LineWidth',1.1);
%hold on
semilogy(10*log10(SNR),theoretical_BER,'-*',10*log10(SNR),BER_ML,'-o',10*log10(SNR),BER_MAP,'-d');
%hold off
legend('Theoretical BER of MAP','Simulated BER(ML)','Simulated BER(MAP)');
title('BER curve(Non equal a priori probability)');
xlabel('SNR(dB)=2Eb/N0');ylabel('BER');
ylim([10^-5 1]);
grid minor
grid on