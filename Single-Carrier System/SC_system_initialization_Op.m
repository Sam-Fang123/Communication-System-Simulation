function [pilot,data,observation,contaminating_data,w,U,A,Rc] = SC_system_initialization_Op(sys_par,tx_par,ts_par,est_par,td_window,fade_struct)

    %window generate
    w = window_design(sys_par.tblock,td_window.Q,fade_struct.nor_fd,td_window.type);

    %BEM Matrix
    U = [];
    switch(est_par.BEM.type)
        case(1)
            U = BEM_CE_Basis_Matrix(sys_par.tblock,est_par.BEM.Q);
        case(2) 
            U = BEM_GCE_Basis_Matrix(sys_par.tblock,est_par.BEM.Q);
        case(3)
            U = BEM_P_Basis_Matrix(sys_par.tblock,est_par.BEM.Q);
    end
    U = diag(w)*U; %let the basis matrix absorb the-time domain window
    U = orth(U);
    % Optimal power allocation
    power_allocation = 1/(1+sqrt((sys_par.L+1)/floor(sys_par.ndata/sys_par.G)));
    %power_allocation=0.5;
    pilot.power = sys_par.tblock*(1-power_allocation)/sys_par.G;
    data.power = sys_par.tblock*power_allocation/sys_par.ndata;
    
    %Calculate the starting index and length of each cluster(Pg,Dg,Og)
    %Then the positions are also calculated
    subblock_length = floor(sys_par.tblock/sys_par.G);
    pilot.start_index = (1:sys_par.G)*subblock_length-sys_par.P;
    
    observation.start_index = pilot.start_index + est_par.l;
    pilot.start_index = mod(pilot.start_index-1,sys_par.tblock)+1;
    observation.start_index = mod(observation.start_index-1,sys_par.tblock)+1;
    
    pilot.cluster_length = sys_par.P+1;
    observation.cluster_length  = sys_par.P + sys_par.M - 2*est_par.l;
    contaminating_data.oneside_length = sys_par.M - 1 - est_par.l;
    
    pilot.position = zeros(sys_par.G,pilot.cluster_length); %each row contains indices of pilots corresponds to gth cluster
    observation.position = zeros(sys_par.G,observation.cluster_length);%each row contains indices of observation points corresponds to gth cluster
    contaminating_data.position = zeros(sys_par.G,2*contaminating_data.oneside_length);%each row contains indices of unknown datas which contaminating the gth observation cluster
    
    for g = 1:sys_par.G
        pilot.position(g,:) = pilot.start_index(g):pilot.start_index(g) + pilot.cluster_length-1; 
        observation.position(g,:) = observation.start_index(g):observation.start_index(g) + observation.cluster_length-1;
        contaminating_data.position(g,:) = [pilot.start_index(g)-contaminating_data.oneside_length:pilot.start_index(g)-1  pilot.start_index(g)+pilot.cluster_length:pilot.start_index(g)+pilot.cluster_length+contaminating_data.oneside_length-1];
    end
    
    pilot.position = mod(pilot.position-1,sys_par.tblock)+1;
    observation.position = mod(observation.position-1,sys_par.tblock)+1;
    contaminating_data.position = mod(contaminating_data.position-1,sys_par.tblock)+1;
    
    if(sys_par.cpzp_type==2)    % ZP
        pilot.position = [reshape(pilot.position.',1,[]) subblock_length*sys_par.G+1:sys_par.tblock];
    end
    data.position = setdiff(1:sys_par.tblock, reshape(pilot.position.',1,[]));
    
    %pilot generate
    rand('state',sys_par.pilot_random_seed);
    randn('state',sys_par.pilot_random_seed);
    %only the middle pilot is nonzero pilot, and the average energy is same as data symbol
    [const_pn dec_pn bit_pn]=block_sym_mapping(1,tx_par,ts_par,2);% generate TS seq (all blocks have same TS) %ts_par=1
    pilot.clusters_symbol = [zeros(sys_par.G,floor((sys_par.P+1)/2)) const_pn*ones(sys_par.G,1)*sqrt(pilot.power) zeros(sys_par.G,floor((sys_par.P+1)/2))];%each row is a pilot cluster
    pilot.clusters_dec = [zeros(sys_par.G,floor((sys_par.P+1)/2)) dec_pn*ones(sys_par.G,1) zeros(sys_par.G,floor((sys_par.P+1)/2))];%each row is a pilot cluster
    
    
    %Channel Estimation Model Construct...
    %1. Once BEM model and pilots are known, the estimator matrix A is known. 
    %2. The only changing thing is the received observation vector y.
    A = [];
    for g = 1:sys_par.G

        p_start_index = sys_par.L;
        P_circulant = zeros(pilot.cluster_length-sys_par.L);
        for p = 0:sys_par.L
            P_circulant(:,p+1) =  pilot.clusters_symbol(g,p_start_index+1:p_start_index+sys_par.L+1);
            p_start_index = p_start_index-1;
        end

        %P_circulant = P_circulant(observation.position(g,:),mod(pilot.start_index(g):pilot.start_index(g) + sys_par.M -1, sys_par.tblock));

        Ag = [];
        for i = 1:est_par.BEM.I
            U_diag = diag(U(:,i));
            Ag = [Ag U_diag(observation.position(g,:),observation.position(g,:))*P_circulant];
        end
        A = [A;Ag];
    end
    
    if(sys_par.cpzp_type==2)    %ZP
        pilot.clusters_symbol = [reshape(pilot.clusters_symbol.',1,[]) zeros(1,sys_par.tblock-subblock_length*sys_par.G)];
        pilot.clusters_dec = [reshape(pilot.clusters_dec.',1,[]) zeros(1,sys_par.tblock-subblock_length*sys_par.G)];
    end
    pilot.position = reshape(pilot.position.',1,[]);
    index = 1:sys_par.nts;
    pilot.on_index = index(reshape((pilot.clusters_symbol~=0).',1,[]));
    pilot.on_num = size(pilot.on_index,2);
    pilot.off_index = reshape((pilot.clusters_symbol==0).',1,[]);
    %pilot.off_position = pilot.position(reshape((pilot.clusters_symbol==0).',1,[]));
    %pilot.on_position = pilot.position(reshape((pilot.clusters_symbol~=0).',1,[]));
    
    %% Rc
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

                    switch(fade_struct.ch_model)
                        case(3)
                            inv_nrms=1/fade_struct.nrms;
                            var0=((1-exp(-inv_nrms))/(1-exp(-fade_struct.ch_length*inv_nrms))); % c value
                            avg_pwr=var0*exp(-(0:fade_struct.ch_length-1)*inv_nrms);
                        case(4)
                            avg_pwr = 1/fade_struct.ch_length*ones(1,fade_struct.ch_length);
                    end
                    pseudo_U = (U'*U)\(U');
                    Rhl_normalized = pseudo_U*diag(w)*ch_ac_matrix*diag(w')*pseudo_U';
                    Rc = kron(Rhl_normalized,diag(avg_pwr));
       
end