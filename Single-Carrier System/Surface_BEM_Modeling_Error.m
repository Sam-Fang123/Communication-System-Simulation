clc;
clear;
%% Time Domain Window parameter
td_window.str = ["No windowing","MBAE-SOE"];
td_window.type = 1;
td_window.Q = 1;
td_window.complex_exponential_num = td_window.Q*2+1;
%% BEM
BEM.typenum = 3;
BEM.type = 1;
BEM.str = ["CE-BEM","GCE-BEM","P-BEM"];
BEM.I = 3;
BEM.Q = floor(BEM.I/2);  %bases number: 2*Q+1 
%% system parameter
sys_par.tblock = 256;
sys_par.random_seed = 0;
%% channel parameters
fade_struct.ch_length = 5;
fade_struct.fading_flag = 1;
fade_struct.ch_model = 3; % 3:exponential decay fast fading 4:equal variance fast fading
fade_struct.nrms = 10;

fade_struct.fd = 0.2;% multiple of subcarrier spacing
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;

%% tx parameters
tx_par.nblock = 1; % num FFT block
%% initialization
fd_range = 0.02:0.02:1;
I_range = 1:2:7;
I_range=[1 3 5 7];
mean_modeling_error = zeros(size(I_range,2), size(fd_range,2));

for f = 1:size(fd_range,2)
    
    fade_struct.fd = fd_range(f);% multiple of subcarrier spacing
    fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
    
    %window initialized
    w = window_design(sys_par.tblock,td_window.Q,fade_struct.nor_fd,td_window.type);
    
    for i = 1:size(I_range,2)
        
        error = zeros(1,tx_par.nblock);%initialization
        for ii = 1:tx_par.nblock
        
            display(['2Q+1(bases number) & block index ' num2str(I_range(i)) '_' num2str(ii)]);
            %[h] = ZX_gen_ch_imp(fade_struct, sys_par,(ii-1)*(sys_par.tblock + fade_struct.ch_length));
            [h]=gen_ch_imp(fade_struct,sys_par,ii);
            BEM.Q = floor(I_range(i)/2);
            [h_approx,h_taps_approx,c] = BEM_approximation(h,fade_struct.ch_length, BEM.Q, BEM.type,w);
            error(ii) = trace((h-h_approx)*(h-h_approx)');
            
        end
        mean_modeling_error(i,f) = mean(error);
    end
end
figure;
[F,I] = meshgrid(fd_range, I_range);
surf(F,I,mean_modeling_error);
%mesh(F,Q,mean_modeling_error);
%surfl(F,Q,mean_modeling_error);
colormap(winter)    % change color map
%shading interp    % interpolate colors across lines and faces

set(gca, 'ZScale', 'log');
xlim([min(fd_range) max(fd_range)]);
ylim([min(I_range) max(I_range)]);
ylabel("Bases Number");
xlabel("Doppler Frequency(Multiple of carrier spacing)");
title(BEM.str(BEM.type) +" BEM Modeling Error Averaged Over " + num2str(tx_par.nblock) + " times");

%Theoretical value
theoretical_modeling_error = zeros(size(I_range,2), size(fd_range,2));
for f = 1:size(fd_range,2)
    
    fade_struct.fd = fd_range(f);% multiple of subcarrier spacing
    fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
    
    %window initialized
    w = window_design(sys_par.tblock,td_window.Q,fade_struct.nor_fd,td_window.type);
    channel_autocorrelation = besselj(0,(-(sys_par.tblock-1):(sys_par.tblock-1))*2*pi*fade_struct.nor_fd);
    ch_ac_matrix = zeros(sys_par.tblock,sys_par.tblock);
    for p = 1:sys_par.tblock
        element_num = p;
        ch_ac_matrix = ch_ac_matrix + diag(ones(1,element_num),-(p-sys_par.tblock))*channel_autocorrelation(p);
    end
    for p = sys_par.tblock+1:2*sys_par.tblock-1
        element_num = 2*sys_par.tblock-p; 
        ch_ac_matrix = ch_ac_matrix + diag(ones(1,element_num),-(p-sys_par.tblock))*channel_autocorrelation(p);
    end
    inv_nrms=1/fade_struct.nrms;
    var0=((1-exp(-inv_nrms))/(1-exp(-fade_struct.ch_length*inv_nrms))); % c value
    avg_pwr=var0*exp(-(0:fade_struct.ch_length-1)*inv_nrms);
    Rh = kron(ch_ac_matrix,diag(avg_pwr));
    for i = 1:size(I_range,2)
        BEM.Q = floor(I_range(i)/2);
        switch(BEM.type)
            case 1 %CE-BEM approximation
                U = BEM_CE_Basis_Matrix(sys_par.tblock,BEM.Q);
            case 2 %GCE-BEM approximation 
                U = BEM_GCE_Basis_Matrix(sys_par.tblock,BEM.Q);
            case 3 %P-BEM approximation
                U = BEM_P_Basis_Matrix(sys_par.tblock,BEM.Q);
        end
        U = diag(w)*U;
        U = orth(U);
        temp = kron(U,eye(fade_struct.ch_length));
        U_proj = temp*temp';
        temp2 = eye(sys_par.tblock*fade_struct.ch_length)-U_proj;
        theoretical_modeling_error(i,f) = trace(temp2*Rh*temp2');
    end
end
figure;
[F,I] = meshgrid(fd_range, I_range);
surf(F,I,real(theoretical_modeling_error));
colormap(winter)    % change color map

set(gca, 'ZScale', 'log');
xlim([min(fd_range) max(fd_range)]);
ylim([min(I_range) max(I_range)]);
ylabel("Bases Number");
xlabel("Doppler Frequency(Multiple of carrier spacing)");
title("Theoretical "+ BEM.str(BEM.type) +" BEM Modeling Error");
