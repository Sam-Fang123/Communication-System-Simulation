
clear
bitnum = 10^5;
block_num = bitnum/2;

% Flat fading channel
velocity = 90;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 10^-5;      % sampling freq MHZ   % This sampling freq is to match the coherence time ??
N0 = 20;

rx_num = 2;
channel_num = rx_num*2;
fade_coeff = zeros(channel_num, block_num);
inphase = zeros(channel_num, N0+1);

% initial phase uniformly distributed in [0,2*pi]
rng('default');
inphase = 2*pi*rand(channel_num, N0+1);

for i = 1:channel_num
    [fade_coeff(i,:),inphase(i,:)] = spfade(velocity,Fc,Fs,N0,block_num,inphase(i,:));
end

inphase_mrrc = 2*pi*rand(4,N0+1);
for i = 1:4
    [fade_coeff_mrrc(i,:),inphase_mrrc(i,:)] = spfade(velocity,Fc,Fs,N0,bitnum,inphase_mrrc(i,:));
end

% AWGN noise
SNR_db = 1:50;
SNR_lin = 10.^(SNR_db/10);  % SNR = symbol power/(noise power on each part)
noise_pow = 1./(SNR_lin);  % noise power = 1/(SNR), assume symbol power = 1
BER_bpsk = zeros(1,length(SNR_db));
BER_2x1 = zeros(1,length(SNR_db));
BER_2x2 = zeros(1,length(SNR_db));
BER_1x2 = zeros(1,length(SNR_db));
BER_1x4 = zeros(1,length(SNR_db));

% Let mrrc's total transmitted power = alomouti's code transmitted total power
% So I need to multiply sqrt(2)
input1 = sqrt(2)*(2*(rand(1,bitnum)>0.5)-1);
input2 = 2*(rand(1,bitnum)>0.5)-1;
r_mrrc = zeros(4,bitnum);

s_2x1_out = zeros(1,bitnum);
s_2x2_out = zeros(1,bitnum);

for i=1:length(SNR_db)
    
    % bpsk and mrrc
    w = sqrt(noise_pow(i))*randn(4,bitnum)+sqrt(-1)*sqrt(noise_pow(i))*randn(4,bitnum); 
    r_bpsk = input1.*fade_coeff_mrrc(1,:) + w(1,:);
    r_mrrc = fade_coeff_mrrc.*[input1;input1;input1;input1] + w;
    
    s0_bpsk = r_bpsk ./ fade_coeff_mrrc(1,:);
    s0_1x2 = sum(conj(fade_coeff_mrrc(1:2,:)).*r_mrrc(1:2,:),1);
    s0_1x4 = sum(conj(fade_coeff_mrrc).*r_mrrc,1);
    
    output_bpsk = sqrt(2)*((s0_bpsk > 0)*2-1);
    output_1x2 = sqrt(2)*((s0_1x2 > 0)*2-1);
    output_1x4 = sqrt(2)*((s0_1x4 > 0)*2-1);
    
    BER_bpsk(i) = sum(output_bpsk~=input1)/bitnum;
    BER_1x2(i) = sum(output_1x2~=input1)/bitnum;
    BER_1x4(i) = sum(output_1x4~=input1)/bitnum;
    
    % Alamouti code
    for j=1:block_num
        H_eff=[fade_coeff(1,j) fade_coeff(2,j);conj(fade_coeff(2,j)) -conj(fade_coeff(1,j));fade_coeff(3,j) fade_coeff(4,j);conj(fade_coeff(4,j)) -conj(fade_coeff(3,j))];
        r_2x2 =  H_eff*[input2(2*j-1);input2(2*j)] + w(:,j);
        s_2x1 = transpose(conj(H_eff(1:2,:)))*r_2x2(1:2);
        s_2x2 = transpose(conj(H_eff))*r_2x2;
        % Don't cascade directly, it will cause run time be too long
        % Instead, allocate the vector first (line43,44)
        s_2x1_out(2*j-1) = s_2x1(1);
        s_2x1_out(2*j) = s_2x1(2);
        s_2x2_out(2*j-1) = s_2x2(1);
        s_2x2_out(2*j) = s_2x2(2);
    end
    
    output_2x1 = (s_2x1_out > 0)*2-1;
    output_2x2 = (s_2x2_out > 0)*2-1;
    BER_2x1(i) = sum(output_2x1~=input2)/bitnum;
    BER_2x2(i) = sum(output_2x2~=input2)/bitnum;
end

figure;
semilogy(SNR_db, BER_bpsk,'o-');
hold on;
semilogy(SNR_db, BER_1x2,'v-');
hold on;
semilogy(SNR_db, BER_1x4,'s-');
hold on;
semilogy(SNR_db, BER_2x1,'d-');
hold on;
semilogy(SNR_db, BER_2x2,'^-');
ylim([10^(-6) 1]);
grid;

legend("No Diversity BPSK(1 Tx, 1 Rx)","MRRC(1 Tx, 2 Rx)","MRRC(1 Tx, 4Rx)","Alamouti Code(2 Tx, 1Rx)","Alamouti Code(2 Tx, 2Rx)");
title("BPSK over Rayleigh Fading Channel with MRRC and Alamouti Code");
xlabel("SNR(dB)");
ylabel("BER");
    
