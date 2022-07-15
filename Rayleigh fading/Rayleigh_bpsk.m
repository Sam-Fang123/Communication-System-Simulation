
clear
bitnum = 10^5;
block_num = bitnum/2;

% Flat fading channel
velocity = 90;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 10^-5;      % sampling freq MHZ   % This sampling freq is to match the coherence time ??
N0 = 20;

fade_coeff = zeros(1, bitnum);
inphase = zeros(1, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(1, N0+1);
[temp_re temp_im fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,bitnum,inphase);

% AWGN noise
SNR_db = 1:50;
SNR_lin = 10.^(SNR_db/10);  % SNR = symbol power/(noise power on each part)
noise_pow = 1./(SNR_lin);  % noise power = 1/(SNR), assume symbol power = 1
BER_bpsk = zeros(1,length(SNR_db));

% Let mrrc's total transmitted power = alomouti's code transmitted total power
% So I need to multiply sqrt(2)
input1 = (2*(rand(1,bitnum)>0.5)-1);
for i=1:length(SNR_db)
    
    % bpsk and mrrc
    w = sqrt(noise_pow(i))*randn(1,bitnum)+sqrt(-1)*sqrt(noise_pow(i))*randn(1,bitnum); 
    r_bpsk = input1.*fade_coeff + w;
    s0_bpsk = r_bpsk ./ fade_coeff;
    output_bpsk = ((s0_bpsk > 0)*2-1);
    BER_bpsk(i) = sum(output_bpsk~=input1)/bitnum;
  
 
end

figure(2);
semilogy(SNR_db, BER_bpsk,'o-');
hold on;
semilogy(SNR_db, (1-sqrt((SNR_lin/2)./((SNR_lin/2)+1)))/2);
% Check the relationship of SNR and transmission power!!!

legend("No Diversity BPSK(1 Tx, 1 Rx)","the");
title("BPSK over Rayleigh Fading Channel with MRRC and Alamouti Code");
xlabel("SNR(dB)");
ylabel("BER");
    
