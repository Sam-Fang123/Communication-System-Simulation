function [fade_coeff,inphase] = fastfade(fd,N0,Nsample,inphase)

fade_coeff = zeros(1,Nsample);  % will store the output
% derived parameters

wm = 2*pi*fd;
N = 2*(2*N0+1);

% fading coefficient generation 

temp_re = zeros(1,Nsample);
temp_im = zeros(1,Nsample);

j=1:N0;
  beta = pi*j/N0;
  cbeta = cos(beta);
  sbeta = sin(beta);
  wn    = wm*cos(2*pi*j/N);


i=1:Nsample;
  CC = wn.' * i + (inphase(2:N0+1)).' * ones(1,Nsample);  % now a matrix
  CC = cos(CC);
  temp_re = ( 2*cbeta*CC + cos(wm*i+inphase(1)) )/sqrt(2*(N0+0.5));
  temp_im = ( 2*sbeta*CC + cos(wm*i+inphase(1)) )/sqrt(2*(N0+0.5)); 
    
% make it complex
fade_coeff = temp_re + sqrt(-1) * temp_im;
  
% update the inphase[]
inphase(2:N0+1) = inphase(2:N0+1) + wn *Nsample;   
inphase(1) = inphase(1) + wm*Nsample;  

