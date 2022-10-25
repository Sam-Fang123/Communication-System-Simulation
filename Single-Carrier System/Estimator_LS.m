function [h_est, h_taps_est, c_est] = Estimator_LS(sys_par,A,y_O,U)

    %c_est = (A'*A)\A'*y_O;
    c_est = pinv(A)*y_O;
    h_taps_est = U*reshape(c_est,sys_par.M,[]).';

    h_est = [fliplr(h_taps_est) zeros(sys_par.tblock,sys_par.tblock-sys_par.M)];
    for i = 0:sys_par.tblock-1
        h_est(i+1,:) = circshift(h_est(i+1,:), -(sys_par.M-1-i),2);
    end
    
end
