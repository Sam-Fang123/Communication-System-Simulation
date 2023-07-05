function [] = plot_BEM_estimated_channel(sys_par,h_taps,h_taps_est, h_taps_approx)

    f1 = figure;
    N = sys_par.tblock;
    M = sys_par.M;
        
    points = 16;
    ds_par = N/points;
    marker_indices = downsample(1:N,ds_par);
    all_marks = {'o','>','d','^','p','s','h','>','v','<','*','+','.'};
    colors = ['r','b','g','m','k','c','y'];
    for i = 1:M
        a=rand(1,3);
        plot(1:N,real(h_taps(:,i)), '--','color',colors(mod(i-1,7)+1),'Marker',all_marks{mod(i,13)},'MarkerSize',6,'MarkerIndices',marker_indices,'linewidth' ,0.5,'DisplayName',"channel tap "+num2str(i));hold on;
        plot(1:N,real(h_taps_est(:,i)), '-','color',colors(mod(i-1,7)+1),'Marker',all_marks{mod(i,13)},'MarkerSize',6,'MarkerIndices',marker_indices,'linewidth' ,0.5,'DisplayName',"estimated channel tap "+num2str(i));hold on;
        %plot(1:N,real(h_taps_approx(:,i)), '-.','color',colors(mod(i-1,7)+1),'Marker',all_marks{mod(i,13)},'MarkerSize',6,'MarkerIndices',marker_indices,'linewidth' ,0.5,'DisplayName',"BEM approximated channel tap "+num2str(i));hold on;

    end
    xlim([1 N]);
    grid;
    legend;
    ylabel('Real Channel Gain');
    xlabel('T(Sampling Period)');
    %{
    for i = 1:M
        subplot(M,1,i);
        plot(1:N,real(h_taps(:,i)));
        xlim([1 N]);
        hold on;
        plot(1:N,real(h_taps_est(:,i)));
        xlim([1 N]);
        hold on;
        xlabel("channel tap " + num2str(i));
        legend("original channel","estimated channel");
    end
    han = axes(f1,'visible','off'); 
    han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,'Real Channel Gain');
    xlabel(han,'T(Sampling Period)');
    %title(han,'yourTitle');
    %supxlabel("Ts(Sampling Period)");
    %supylabel("Real Channel Gain");
    %}
    