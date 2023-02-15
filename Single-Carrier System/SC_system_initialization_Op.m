function [pilot,data,observation,contaminating_data,w,U,A] = SC_system_initialization_Op(sys_par,tx_par,ts_par,est_par,td_window,fade_struct)

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
    power_allocation = 1/(1+sqrt((sys_par.L+1)/(sys_par.ndata/sys_par.G))); 
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
    observation.cluster_length = sys_par.P - 2*est_par.l + 1;
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
    
    pilot.position = [reshape(pilot.position.',1,[]) subblock_length*sys_par.G+1:sys_par.tblock];
    data.position = setdiff(1:sys_par.tblock, reshape(pilot.position.',1,[]));
    
    %pilot generate
    rand('state',sys_par.pilot_random_seed);
    randn('state',sys_par.pilot_random_seed);
    %only the middle pilot is nonzero pilot, and the average energy is same as data symbol
    [const_pn dec_pn bit_pn]=block_sym_mapping(1,tx_par,ts_par,2);% generate TS seq (all blocks have same TS) %ts_par=1
    pilot.clusters_symbol = [zeros(sys_par.G,floor((sys_par.P+1)/2)) const_pn*ones(sys_par.G,1)*sqrt(pilot.power) zeros(sys_par.G,floor((sys_par.P+1)/2))];%each row is a pilot cluster
    pilot.clusters_dec = [zeros(sys_par.G,floor((sys_par.P+1)/2)) dec_pn*ones(sys_par.G,1) zeros(sys_par.G,floor((sys_par.P+1)/2))];%each row is a pilot cluster
    
    pilot.clusters_symbol = [reshape(pilot.clusters_symbol.',1,[]) zeros(1,sys_par.tblock-subblock_length*sys_par.G)];
    pilot.clusters_dec = [reshape(pilot.clusters_dec.',1,[]) zeros(1,sys_par.tblock-subblock_length*sys_par.G)];
    
    
    %Channel Estimation Model Construct...
    %1. Once BEM model and pilots are known, the estimator matrix A is known. 
    %2. The only changing thing is the received observation vector y.
    % 改到這邊!!!!
    A = [];
    for g = 1:sys_par.G

        pg = [pilot.clusters_symbol(g,:).' ;zeros(sys_par.tblock - (sys_par.P+1),1)];
        P_circulant = [];
        for p = 1:sys_par.tblock
            P_circulant = [P_circulant circshift(pg,p-1)]; 
        end

        P_circulant = P_circulant(observation.position(g,:),mod(pilot.start_index(g):pilot.start_index(g) + sys_par.M -1, sys_par.tblock));

        Ag = [];
        for i = 1:est_par.BEM.I
            U_diag = diag(U(:,i));
            Ag = [Ag U_diag(observation.position(g,:),observation.position(g,:))*P_circulant];
        end
        A = [A;Ag];
    end
       
end