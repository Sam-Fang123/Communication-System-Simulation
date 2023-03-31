function [h_approx,h_taps_approx,c] = BEM_approximation(h,channel_length, Q, type,w,est_par)
    
    N = size(h,1);
    if(est_par.BEM.window==1)   % OW-basis
      h = diag(w)*h;
    end
    
    %transform h to discrete random process form ==> each column is a
    %random process of one tap
    h_taps = zeros(N, N);
    for i = 0:N-1
        h_taps(i+1,:) =  circshift(h(i+1,:), channel_length-1-i,2);
    end
    h_taps = fliplr(h_taps(:,1:channel_length));

    %bases construct
    U = zeros(N, 2*Q+1);
    switch type
        case 1 %CE-BEM approximation
            U = BEM_CE_Basis_Matrix(N,Q);
        case 2 %GCE-BEM approximation 
            U = BEM_GCE_Basis_Matrix(N,Q);
        case 3 %P-BEM approximation
            U = BEM_P_Basis_Matrix(N,Q);
    end
    if(est_par.BEM.window==1)
        U = diag(w)*U;
    end
    U = orth(U);
    %least square approximation
    %c = (U'*U)\U'*h_taps;
    c = pinv(U)*h_taps;
    h_taps_approx = U*c;
    %h_taps_approx = U*((U'*U)\U')*h_taps;
    %h_taps_approx = U*(U\h_taps);
    %h_taps_approx = U*pinv(U)*h_taps;
    
    h_approx = [fliplr(h_taps_approx) zeros(N,N-channel_length)];
    for i = 0:N-1
        h_approx(i+1,:) = circshift(h_approx(i+1,:), -(channel_length-1-i),2);
    end
    c = reshape(c.',[],1);
end