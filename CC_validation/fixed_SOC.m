%% get RUL when SOC fixed in each scenario, current sampled from feasible region (change 5 times at different HI); correspond to part1 simulation in the paper
clear;clc;rng(7);
data=struct;
data.RUL={};

% F1
% Id=[11.7,11.7,10.9,6.2,2.8];
% Ic=[3,2.6,2.3,2.3,2.3]; %0,200,400,600,800 SOC 20%-80%

% Id=[11.7,11.7,11.7,11.7,5.9];
% Ic=[4.3,3.8,3.2,2.5,2.3]; %0,200,400,600,800 SOC 1%-40%

Id=[11.7,11.7,11.7,8.3,3.6];
Ic=[3.4,2.9,2.5,2.3,2.3]; %0,200,400,600,800 SOC 1%-60%

epoch=1;batch_size=64;

for i=1:epoch
    RUL=[];    
    
    for j=1:batch_size      
        
        in(j) = Simulink.SimulationInput('CC_dynamic_2019a');
        in(j) = in(j).setBlockParameter(...
            'CC_dynamic_2019a/Relay4','OnOutputValue',num2str(-unifrnd(2.3,Id(1))),...
            'CC_dynamic_2019a/Relay4','OffOutputValue',num2str(unifrnd(2.3,Ic(1))),...                       
            'CC_dynamic_2019a/Relay','OnOutputValue',num2str(-unifrnd(2.3,Id(2))),...
            'CC_dynamic_2019a/Relay','OffOutputValue',num2str(unifrnd(2.3,Ic(2))),...
            'CC_dynamic_2019a/Relay1','OnOutputValue',num2str(-unifrnd(2.3,Id(3))),...
            'CC_dynamic_2019a/Relay1','OffOutputValue',num2str(unifrnd(2.3,Ic(3))),...
            'CC_dynamic_2019a/Relay2','OnOutputValue',num2str(-unifrnd(2.3,Id(4))),...
            'CC_dynamic_2019a/Relay2','OffOutputValue',num2str(unifrnd(2.3,Ic(4))),...
            'CC_dynamic_2019a/Relay3','OnOutputValue',num2str(-unifrnd(2.3,Id(5))),...
            'CC_dynamic_2019a/Relay3','OffOutputValue',num2str(unifrnd(2.3,Ic(5)))...
            );                                                
    end
    simOut=parsim(in);
    
    for j=1:batch_size
        try
            RUL=[RUL;simOut(j).tout(end)/3600];            
            
        catch
            continue
        end
    end
    data.RUL(i)={RUL};
    
    save(strcat('./data/CC_fixed_SOC5_3.mat'), 'data', '-v7.3');
end

% F2
% Id=[5.6,4.4,3.2,2.3,2.3];
% Ic=[4.3,4.3,4.3,4.2,2.6]; %0,200,400,600,800 SOC 20%-80%

% Id=[11.7,9.1,6.4,4.1,2.3];
% Ic=[4.3,4.3,4.3,4.3,4.1]; %0,200,400,600,800 SOC 1%-40%

Id=[7.2,5.5,4,2.7,2.3];
Ic=[4.3,4.3,4.3,4.3,3]; %0,200,400,600,800 SOC 1%-60%

epoch=1;batch_size=64;

for i=1:epoch
    RUL=[];    
    
    for j=1:batch_size      
        
        in(j) = Simulink.SimulationInput('CC_dynamic_2019a');
        in(j) = in(j).setBlockParameter(...
            'CC_dynamic_2019a/Relay4','OnOutputValue',num2str(-unifrnd(2.3,Id(1))),...
            'CC_dynamic_2019a/Relay4','OffOutputValue',num2str(unifrnd(2.3,Ic(1))),...                       
            'CC_dynamic_2019a/Relay','OnOutputValue',num2str(-unifrnd(2.3,Id(2))),...
            'CC_dynamic_2019a/Relay','OffOutputValue',num2str(unifrnd(2.3,Ic(2))),...
            'CC_dynamic_2019a/Relay1','OnOutputValue',num2str(-unifrnd(2.3,Id(3))),...
            'CC_dynamic_2019a/Relay1','OffOutputValue',num2str(unifrnd(2.3,Ic(3))),...
            'CC_dynamic_2019a/Relay2','OnOutputValue',num2str(-unifrnd(2.3,Id(4))),...
            'CC_dynamic_2019a/Relay2','OffOutputValue',num2str(unifrnd(2.3,Ic(4))),...
            'CC_dynamic_2019a/Relay3','OnOutputValue',num2str(-unifrnd(2.3,Id(5))),...
            'CC_dynamic_2019a/Relay3','OffOutputValue',num2str(unifrnd(2.3,Ic(5)))...
            );                                                
    end
    simOut=parsim(in);
    
    for j=1:batch_size
        try
            RUL=[RUL;simOut(j).tout(end)/3600];            
            
        catch
            continue
        end
    end
    data.RUL(i+1)={RUL};
    
    save(strcat('./data/CC_fixed_SOC5_3.mat'), 'data', '-v7.3');
end