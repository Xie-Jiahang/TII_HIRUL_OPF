%% get CC RUL & Id, Ic data under different SOC ranges/scenarios around the feasible region upper right boundaries to facilitate the construction of confidence interval
clear;clc;rng(7);
folder='C:\Users\jiahang001\OneDrive - Nanyang Technological University\extension\CCCV_RUL_Id_Ic';
addpath(genpath(folder));
pause(1);

SOC_max=[98,80,40,60,98,98,60];
SOC_min=[1,20,1,1,40,60,40];

load('../data/con_extreme_point.mat');
sample_size=64;

for sce=2:4
    data=struct;
    data.Id=[];data.Ic=[];data.RUL=[];
    data.V_max={};data.V_min={};data.P={};            
    
for i=1:2
    
for j=1:sample_size
    Id=unifrnd(2.3*0.9,extreme_point(sce,1));
    data.Id=[data.Id;Id];
    Ic=unifrnd(2.3*0.9,extreme_point(sce,end));
    data.Ic=[data.Ic;Ic];

    in(j) = Simulink.SimulationInput('CC_2019a');
    in(j) = in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-Id),...
        'CC_2019a/Relay','OffOutputValue',num2str(Ic),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(Id),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(Ic)...
        );
end
simOut=parsim(in);

for j=1:sample_size
    try
        data.RUL=[data.RUL;simOut(j).tout(end)/3600];
        [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
        data.V_max(i,j)={V_max};
        data.V_min(i,j)={V_min};

        [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(simOut(j).battery_Power);
        data.P(i,j)={[P_c_mean,P_c_max,P_d_mean,P_d_max]};
    catch
        continue
    end
end

save(strcat('../data/CC_CI',num2str(sce),'.mat'), 'data', '-v7.3');
   
end
end
rmpath(genpath(folder));