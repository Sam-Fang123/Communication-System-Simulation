%%  Assumption on data
clear all
bits_num=128*10^4;    % # of bits
fft_size=64;          % fft size
input=rand(1,bits_num);     
X(input>0.5)=1;       % X:Input bits
X(input<=0.5)=-1;

%% Channel assumption
h=[1 zeros(1,fft_size-1)];      % AWGN channel impulse response
Q=eye(fft_size);    % Time domain convolution matrix
H=fft(h,fft_size);   % AWGN channel frequency response
H_matrix=diag(H);    % Frequency domain matrix  

%% SNR
OFDM_symbol_power=1;
SNR=1:25;                % SNR = 1/(2*noise power on each part)
noise_pow=1./(2*SNR);  % noise power = 1/(2*SNR) 
BER=zeros(1,length(SNR));
%%
for j=1:length(SNR)
    error_num=0;
    for i=0:fft_size:length(X)-fft_size
        %% TX
        x=ifft(X(i+1:i+fft_size),fft_size)*sqrt(fft_size);     % x = ifft(X)
        %% Channel, y: Received signal, Q: Convolution matrix
        y=Q*transpose(x)+sqrt(noise_pow(j))*randn(fft_size,1)+sqrt(-1)*sqrt(noise_pow(j))*randn(fft_size,1); 
        % y = Q*x + w, w is complex gaussian random vector
        %% RX
        Y=fft(y,fft_size)/sqrt(fft_size);     % Y = fft(y)
        X2=inv(H_matrix)*Y;      % X2=Y/H (Equalization)
        X2=transpose(X2);
        %% Detection
        Output(X2>=0)=1;
        Output(X2<0)=-1;
        error_num=error_num+sum(Output~=X(i+1:i+fft_size));
    end
    BER(j)=error_num/bits_num;
end
%%
figure(1)
theoretical_BER=qfunc(sqrt(2*SNR));  % Theoretical BER
semilogy(10*log10(SNR),BER,'-o');
hold on
semilogy(10*log10(SNR),theoretical_BER,'-*');
legend('Simulation BER','Theoretical BER (Q[sqrt(2*SNR)]')
title('BER curve');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
ylim([10^-5 1]);
OFDM_symbol_power=mean(conj(transpose(x))*x)/fft_size;   % Power = E[||x||^2] 
