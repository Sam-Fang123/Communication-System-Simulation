function [h_est, h_taps_est, c_est] = Estimator_Iterative_BLUE(sys_par,A,y_O,noise_pwr,observation,contaminating_data,est_par,U,w)

        M = sys_par.M;
        N = sys_par.tblock;
        G = sys_par.G;

        Rz = noise_pwr*diag(w)*diag(w');
        Rz = Rz(reshape(observation.position.',1,[]),reshape(observation.position.',1,[]));
        for ii = 1:est_par.BLUE_iterative_times
            if(ii == 1)
                c_est = (A'*(Rz\A))\A'*(Rz\y_O);
            else
                               
                row_distance = size(observation.position,2);
                column_distance = size(contaminating_data.position,2);
                h_data_related = zeros(row_distance*G,column_distance*G);
                for g = 1:G
                    h_data_related((g-1)*row_distance+1:g*row_distance,(g-1)*column_distance+1:g*column_distance) = h_est(observation.position(g,:),contaminating_data.position(g,:));
                end
                               
                Ri = h_data_related*h_data_related';
                Re = Ri + Rz;
                c_est = (A'*(Re\A))\A'*(Re\y_O);
            end
            
            %reconstruct channel matrix
            h_taps_est = U*reshape(c_est,M,[]).';
            h_est = [fliplr(h_taps_est) zeros(N,N-M)];
            for jj = 0:N-1
                h_est(jj+1,:) = circshift(h_est(jj+1,:), -(M-1-jj),2);
            end
            
        end