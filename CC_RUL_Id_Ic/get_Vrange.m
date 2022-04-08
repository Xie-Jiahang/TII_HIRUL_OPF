%% get CC&CCCV maximum & minimum voltage points to facililate mean(max) or mean(min) to get the final V_max & V_min
function [V_max,V_min]=get_Vrange(voltage_data)

V_max=[];V_min=[];step=5;
parfor i=step+1:length(voltage_data)-step-1
    point=voltage_data(i);
    if point>voltage_data(i-step) && point>voltage_data(i+step) && point>3.3
        V_max=[V_max;point];
    elseif point<voltage_data(i-step) && point<voltage_data(i+step) && point<3.3
        V_min=[V_min;point];
    end
end

end