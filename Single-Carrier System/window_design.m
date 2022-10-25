function w = window_design(N,Q,fd,type)
    
    switch(type)
        case 1
            w = ones(N,1);
        case 2
            %A
            m = 0:N-1;
            n = 0:N-1;
            [n_index, m_index] = meshgrid(n,m);
            A = sin(pi*(2*Q+1)*(n_index-m_index)/N)./sin(pi*(n_index-m_index)/N)/N;
            A(isnan(A)) = (2*Q+1)/N;
            %figure;
            %surf(n_index,m_index,A);

            %P
            channel_autocorrelation = besselj(0,(-(N-1):(N-1))*2*pi*fd);
            ch_ac_matrix = zeros(N,N);
            for p = 1:N
                element_num = p;
                ch_ac_matrix = ch_ac_matrix + diag(ones(1,element_num),-(p-N))*channel_autocorrelation(p);
            end
            for p = N+1:2*N-1
                element_num = 2*N-p; 
                ch_ac_matrix = ch_ac_matrix + diag(ones(1,element_num),-(p-N))*channel_autocorrelation(p);
            end
            %figure;
            %surf(n_index,m_index,ch_ac_matrix);

            target = ch_ac_matrix.*A;
            %figure;
            %surf(n_index,m_index,target);

            %Basis Matrix
            U = zeros(N, 2*Q+1);
            Q_range = -Q:1:Q;
            time_range = 0:N-1;
            base_freq = exp(2*pi*1j*Q_range./N);
            for t = time_range
                U(t+1,:) = base_freq.^t;
            end
            U = U/sqrt(N);

            %Calculate window coefficients
            target = U'*target*U;
            [V,D] = eig(target);
            [max_eigenvalue, max_index] = max(max(D));
            b = V(:,max_index);
            w = U*b;
        case 3
            w = Tang_ODM_window(N,Q,fd);
    
    end
    w = w/sqrt(trace(w*w'))*sqrt(N);
    %{
    F = fft(eye(N),N)/sqrt(N);
    F_H = ifft(eye(N),N)*sqrt(N);
    W = F*diag(w)*F_H;
    figure;
    surf(n_index,m_index,abs(W));
    %}