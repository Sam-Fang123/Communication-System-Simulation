% spfade.m  (SpeedUp, UNnormalized version - from AST's channel simulator)
% This routine uses N0 sinusoids to approximate (in-phase & quadrature) 
% Gaussain and then uses the envelope of the complex gaussian to approximate
% the Rayleigh distribution.
% 
% I/O parameters:
%   - fade_coeff: (Nsample-by-1) complex fading coeff   
%   - inphase   : 
%                 as an output argument, "inphase" can be used as
%                 for the generation of the next block of fading coefficients.
%                 By doing so, the phases of the fading coefficients remain
%                 continuous.
%   - velocity  : mobile velocity in km/hr
%   - Fc = 900  : carrier freq in MHz
%   - Fs = 1.2288*4 : sampling freq MHZ 
%   - N0 = normally set to be 20 (# of sinusoids used for approximating Gaussian)
%   - Nsample:     Nsample-by-1 complecx coefficients

function [temp_re temp_im fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,Nsample,inphase)

% parameters
scale_const = 1.08*10^9;     % used to compute doppler spread in Hz

fade_coeff = zeros(1,Nsample);  % will store the output

% derived parameters
% fd=v*cos(theta)/wavelength, wavelength=C/freq, C is light velocity 
% w=WTs=W/fs(By dsp, w is digit freq and W is analog freq), so
% fd=v*freq*cos/C/fs
Doppler_shift = velocity*(Fc*10^6)/scale_const
Coherence_time = 1/Doppler_shift
Ts = 1/(Fs*10^6)
fd = velocity*Fc/Fs/scale_const       
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

% old version, slow!
%for i=1:Nsample
%        
%    cc = cos(wn.*i+inphase(2:N0+1));
%    temp_re(i) = (sum( 2*cbeta .* cc ) + cos( wm*i+inphase(1) ))/sqrt(2*(N0+0.5));
%    temp_im(i) = (sum( 2*sbeta .* cc ) + cos( wm*i+inphase(1) ))/sqrt(2*(N0+0.5));
%    
%    % normalize such that E[temp_re^2] = E[temp_im^2] = 0.5 
%
%end  % end of each block 
  
% make it complex
fade_coeff = temp_re + sqrt(-1) * temp_im;
  
% update the inphase[]
inphase(2:N0+1) = inphase(2:N0+1) + wn *Nsample;   
inphase(1) = inphase(1) + wm*Nsample;  

