
function [b_hat]=Iter_SC_window(sys_par,rx_par,fade_struct,snr)

D = (rx_par.K-1)/2;
A = zeros(sys_par.tblock,sys_par.tblock);
R = zeros(sys_par.tblock,sys_par.tblock);
N = sys_par.tblock;

for m = 1:sys_par.tblock
    for n = 1:sys_par.tblock
        if(m==n)
            A(m,n) = 1;
        else
            A(m,n) = sin((pi/N)*(2*D+1)*(n-m))/(N*sin(pi*(n-m)/N));
        end
        R(m,n) = besselj(0,2*pi*fade_struct.fd*(m-n));
    end
end
b_hat = eig(A.*R,(snr.noise_pwr+1)*eye(N)-A.*R);
