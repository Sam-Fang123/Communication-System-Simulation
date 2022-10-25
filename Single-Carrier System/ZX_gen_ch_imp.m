function [varargout] = ZX_gen_ch_imp(fade_struct,sys_par,start_discrete_time)
if (fade_struct.fading_flag==1)
    
    if (fade_struct.ch_model==1)% slow fading exponential PDP
        inv_nrms=1/fade_struct.nrms;
        var0=((1-exp(-inv_nrms))/(1-exp(-fade_struct.ch_length*inv_nrms))); % c value
        avg_pwr=var0*exp(-(0:fade_struct.ch_length-1)*inv_nrms);
        h = sqrt(0.5*avg_pwr).* (randn(1,fade_struct.ch_length)+1j*randn(1,fade_struct.ch_length));
        
    elseif (fade_struct.ch_model==2)% slow fading uniform PDP
        quasi_ch=rand(1,fade_struct.ch_length);
        h=quasi_ch/norm(quasi_ch);
        
    elseif (fade_struct.ch_model==3 || fade_struct.ch_model==4)% 3: fast fading exponential PDP  4:fast fading uniform PDP
        
        Nsample=sys_par.tblock;
        fd=fade_struct.nor_fd;
        
        if(fade_struct.ch_model==3)
            inv_nrms=1/fade_struct.nrms;
            var0=((1-exp(-inv_nrms))/(1-exp(-fade_struct.ch_length*inv_nrms))); % c value
            avg_pwr=var0*exp(-(0:fade_struct.ch_length-1)*inv_nrms);
        elseif(fade_struct.ch_model==4)
            avg_pwr = 1/fade_struct.ch_length*ones(1,fade_struct.ch_length);
        end    
        h = zeros(fade_struct.ch_length,Nsample);
        for n = 0:fade_struct.ch_length-1
            
            [h(n+1,:)] = ZX_fastfade(n, fd, start_discrete_time, Nsample);
            h(n+1,:)= sqrt(avg_pwr(n+1)).*h(n+1,:);            
        end %end n=0:fade_struct.ch_length-1
        varargout{2} = h.';
        hh=[fliplr(h.') zeros(Nsample,Nsample-fade_struct.ch_length)];
        for m=1:Nsample
            h(m,:)=circshift(hh(m,:),-fade_struct.ch_length+m,2);
%             h(m,:)=circshift(hh(m,:),-sys_par.tblock+m,2);
        end% end m=1:Nsample
        varargout{1} = h;
    else
        error('fader model not supported yet');
    end
    
else% static [1 0 0...] 
    static_ch=[1 zeros(1,fade_struct.ch_length-1) ];
    h=static_ch/norm(static_ch);
end