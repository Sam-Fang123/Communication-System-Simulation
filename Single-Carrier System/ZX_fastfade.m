function [fade_coeff] = ZX_fastfade(tap_index, fd, start_discrete_time, Nsample)

% derived parameters
wd = 2*pi*fd;
M = 50;
rand('state',tap_index);
phase = 2*pi*rand(1,M+2); %ftheta, phi, psi

% fading coefficient generation 
i = 0:Nsample-1;
i = i + start_discrete_time;

alpha = (2*pi*(1:M)-pi + phase(1))./(4*M);
A = cos((wd*i.')*cos(alpha)+phase(2));

temp_re = sqrt(2/M)*(A*cos(phase(3:M+2)).').';
temp_im = sqrt(2/M)*(A*sin(phase(3:M+2)).').';

% make it complex
fade_coeff = temp_re + sqrt(-1) * temp_im;
  