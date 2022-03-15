% test_spfade.m (AST's version, Un-normalized)
% This routine uses N0 sinusoids to approximate (in-phase & quadrature) 
% Gaussain and then uses the envelope of the complex gaussian to approximate
% the Rayleigh distribution.
% 
% See Jake's book for the reference.

% parameters

velocity = 1000;      % mobile velocity in km/hr
Fc = 900;           % carrier freq in MHz
Fs = 1;      % sampling freq MHZ 
                    % (we have 4 samples per pn chip, thus 1.2288*4)
N0 = 20;

Nsample = 10;
fade_coeff = zeros(1,Nsample);

% initial phase uniformly distributed in [0,2*pi]
rand('state',0);
inphase_init = 2*pi*rand(1, N0+1)

% The next for testing N0=20 with the C code 
% inphase = [5.823571  5.706385  1.183162  5.770305  5.988708  0.449248  3.880552  2.137367  2.542542  1.521062  4.055305  6.232087  3.979672  2.385925  3.097502  4.549590  0.625158  1.861988  5.802846  6.181803  1.056276];  

% -------- test the routine 
%[fade_coeff,inphase] = spfade_old(velocity,Fc,Fs,N0,Nsample,inphase_init);
[fade_coeff,inphase] = spfade(velocity,Fc,Fs,N0,Nsample,inphase_init);

% getting the stats
re_fade_coeff = real(fade_coeff);
im_fade_coeff = imag(fade_coeff);
[re_fade_coeff*re_fade_coeff'/length(re_fade_coeff) im_fade_coeff*im_fade_coeff'/length(im_fade_coeff)]
sum(re_fade_coeff.*im_fade_coeff)/length(re_fade_coeff)

% plot the magnitude and phase

figure;
plot(abs(fade_coeff));

if 0
  figure;
  subplot(2,1,1);
  plot(1:Nsample, abs(fade_coeff));
  title(['Magnitude', 'fs = ', num2str(Fs), ', Fc = ', num2str(Fc), ', Velocity = ', num2str(velocity) ]);
  subplot(2,1,2);
  plot(1:Nsample, angle(fade_coeff));
  title(['Phase', 'fs = ', num2str(Fs), ', Fc = ', num2str(Fc), ', Velocity = ', num2str(velocity) ]);
end



