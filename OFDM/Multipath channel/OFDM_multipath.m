

%%  Assumption on data
clear all
bits_num=10^4;    % # of bits
fft_size=64;          % fft size
input=rand(64,bits_num)>0.5;     
X=input*2-1;       % X:Input bits


%% Channel assumption
h=[1 -0.5];      % AWGN channel impulse response
H=fft(h,fft_size);   % AWGN channel frequency response
H_matrix=diag(H);    % Frequency domain matrix  
CP_size=2;           % Length of CP

%% SNR
OFDM_symbol_power=1;
SNR=1:25;                % SNR = 1/(2*noise power on each part)
noise_pow=1./(SNR);  % noise power = 1/(2*SNR)
BER = zeros(fft_size,length(SNR));
%%
for j=1:length(SNR)
    error_num=zeros(fft_size,1);
    for i=1:bits_num
        %% TX
        x=ifft(X(:,i),fft_size)*sqrt(fft_size);     % x = ifft(X)
        x=[x(fft_size-CP_size+1:end);x];       % add CP
        %% Channel, y: Received signal, Q: Convolution matrix
        w=sqrt(noise_pow(j))*randn(fft_size+CP_size+length(h)-1,1)+sqrt(-1)*sqrt(noise_pow(j))*randn(fft_size+CP_size+length(h)-1,1); 
        y=conv(h,x)+w;
        
        %% RX
        Y=fft(y(CP_size+1:end),fft_size)/sqrt(fft_size);     % Y = fft(y)
        X2=inv(H_matrix)*Y;      % X2=Y/H (Equalization)
        %% Detection
        Output(X2>=0)=1;
        Output(X2<0)=-1;
        error_num = error_num + (transpose(Output)~=X(:,i));
    end
    BER(:,j)=error_num/bits_num;
end
average_BER=mean(BER);
%%
figure(1)
theoretical_BER=qfunc(sqrt(SNR));  % Theoretical BER
semilogy(10*log10(SNR),theoretical_BER,'-*');
hold on
semilogy(10*log10(SNR),average_BER,'-o');
legend('Theoretical BER (Q[sqrt(SNR)]','Average BER')
title('BER curve');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
ylim([10^-4 1]);
figure(2)
semilogy(10*log10(SNR),theoretical_BER,'-*');
hold on
semilogy(10*log10(SNR),BER);
legend('Theoretical BER (Q[sqrt(SNR)]','BER of every subcarriers')
title('BER curve of every subcarriers');
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
ylim([10^-4 1]);


