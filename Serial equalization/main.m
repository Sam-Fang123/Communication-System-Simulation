
clear all;
clc;

%% System parameters(Frame structure)
sys_par.tblock = 32; %Blocksize
sys_par.M = 5;%CP length + 1: M
sys_par.pilot_random_seed = 0;
sys_par.pilot_scheme = 1;
sys_par.random_seed = 0;

%% Channel parameters 硄笵把计
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag=1;
fade_struct.ch_model=3;
fade_struct.nrms = 10;

fade_struct.fd = 0.2;% Doppler frequency
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;

%% Tx parameters 肚癳狠把计
tx_par.nblock= 1; % Number of transmitted blocks


%% Transmitted
for ii=1:tx_par.nblock
    [h,h_taps] = gen_ch_imp(fade_struct, sys_par,ii);
end
H_est = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
H_est2=dftmtx(sys_par.tblock)*h*conj(dftmtx(sys_par.tblock))/sys_par.tblock;