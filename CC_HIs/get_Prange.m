%% get CC&CCCV maximum and mean power values in charging/discharging respectively
function [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(power_data)

    P_c=power_data(find(power_data<0));
    P_d=power_data(find(power_data>0));
    
    P_c_mean=mean(abs(P_c));
    P_c_max=max(abs(P_c));
    
    P_d_mean=mean(abs(P_d));
    P_d_max=max(abs(P_d));
    
end