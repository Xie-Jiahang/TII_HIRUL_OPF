%% get CC voltage region based on current region A under different SOC ranges/scenarios
% only run 100h
clear;clc;rng(7);
folder='C:\Users\jiahang001\OneDrive - Nanyang Technological University\extension\CC_RUL_Id_Ic';
addpath(genpath(folder));
pause(1);

SOC_max=[98,80,40,60,98,98,60];
SOC_min=[1,20,1,1,40,60,40];

load('../data/con_extreme_point.mat');
sample_size=64;

for sce=2:4
    data=struct('Id',struct,'Ic',struct);
    data.Id.I_d=[];
    data.Ic.I_c=[];
%% generate from region A
% fix I_c as the possible max value, relationship with I_d
Ic=con_extreme_point(sce,2);
Id=2.3*0.2:2.3*0.1:2.3*0.5;    

for j=1:numel(Id)
    I_d=Id(j);
    data.Id.I_d=[data.Id.I_d;I_d];
    
    in(j) = Simulink.SimulationInput('CC_2019a');
    in(j) = in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-I_d),...
        'CC_2019a/Relay','OffOutputValue',num2str(Ic),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(I_d),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(Ic)...
        );
end
simOut=parsim(in);

for j=1:numel(Id)
    try        
        [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
        data.Id.V_max(sce,j)={V_max};
        data.Id.V_min(sce,j)={V_min};

        [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(simOut(j).battery_Power);
        data.Id.P(sce,j)={[P_c_mean,P_c_max,P_d_mean,P_d_max]};
    catch
        continue
    end
end
save(strcat('../data/CC_VI_regiona',num2str(sce),'.mat'), 'data', '-v7.3');

for j=1:sample_size
    I_d=unifrnd(2.3*0.5,con_extreme_point(sce,3));
    data.Id.I_d=[data.Id.I_d;I_d];
    
    in(j) = Simulink.SimulationInput('CC_2019a');
    in(j) = in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-I_d),...
        'CC_2019a/Relay','OffOutputValue',num2str(Ic),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(I_d),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(Ic)...
        );
end
simOut=parsim(in);

for j=1:sample_size
    try        
        [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
        data.Id.V_max(sce,end+1)={V_max};
        data.Id.V_min(sce,end+1)={V_min};

        [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(simOut(j).battery_Power);
        data.Id.P(sce,end+1)={[P_c_mean,P_c_max,P_d_mean,P_d_max]};
    catch
        continue
    end
end
save(strcat('../data/CC_VI_regiona',num2str(sce),'.mat'), 'data', '-v7.3');

% fix I_d as the possible max value, relationship with I_c
Id=con_extreme_point(sce,3);
Ic=2.3*0.2:2.3*0.1:2.3*0.5;

for j=1:numel(Ic)
    I_c=Ic(j);
    data.Ic.I_c=[data.Ic.I_c;I_c];
    
    in(j) = Simulink.SimulationInput('CC_2019a');
    in(j) = in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-Id),...
        'CC_2019a/Relay','OffOutputValue',num2str(I_c),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(Id),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(I_c)...
        );
end
simOut=parsim(in);

for j=1:numel(Ic)
    try        
        [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
        data.Ic.V_max(sce,j)={V_max};
        data.Ic.V_min(sce,j)={V_min};

        [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(simOut(j).battery_Power);
        data.Ic.P(sce,j)={[P_c_mean,P_c_max,P_d_mean,P_d_max]};
    catch
        continue
    end
end
save(strcat('../data/CC_VI_regiona',num2str(sce),'.mat'), 'data', '-v7.3');

for j=1:sample_size
    I_c=unifrnd(2.3*0.5,con_extreme_point(sce,2));
    data.Ic.I_c=[data.Ic.I_c;I_c];
    
    in(j) = Simulink.SimulationInput('CC_2019a');
    in(j) = in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-Id),...
        'CC_2019a/Relay','OffOutputValue',num2str(I_c),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(Id),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(I_c)...
        );
end
simOut=parsim(in);

for j=1:sample_size
    try       
        [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
        data.Ic.V_max(sce,end+1)={V_max};
        data.Ic.V_min(sce,end+1)={V_min};

        [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(simOut(j).battery_Power);
        data.Ic.P(sce,end+1)={[P_c_mean,P_c_max,P_d_mean,P_d_max]};
    catch
        continue
    end
end
save(strcat('../data/CC_VI_regiona',num2str(sce),'.mat'), 'data', '-v7.3');

end

rmpath(genpath(folder));