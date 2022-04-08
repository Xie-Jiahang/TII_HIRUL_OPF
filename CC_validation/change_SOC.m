%% get RUL when SOC change in each scenario (change 3 times, 6 cases as below at different HI), current sampled from feasible region; correspond to part2 simulation in the paper
% 1 2 3
% 1 3 2
% 2 1 3
% 2 3 1
% 3 1 2
% 3 2 1
clear;clc;rng(7);
data=struct;
data.RUL={};

% F1
Id3=[11.7,10.9,2.8];
Ic3=[3,2.3,2.3]; %0,400,800 SOC 20%-80%

Id2=[11.7,11.7,5.9];
Ic2=[4.3,3.2,2.3]; %0,400,800 SOC 1%-40%

Id1=[11.7,11.7,3.6];
Ic1=[3.4,2.5,2.3]; %0,400,800 SOC 1%-60%

epoch=1;batch_size=64;

for i=1:epoch
    RUL=[];    
    
    for j=1:batch_size      
        
        in(j) = Simulink.SimulationInput('CC_dynamic_case');
        in(j) = in(j).setBlockParameter(...
            'CC_dynamic_case/Relay2','OnOutputValue',num2str(-unifrnd(2.3,Id1(1))),...
            'CC_dynamic_case/Relay2','OffOutputValue',num2str(unifrnd(2.3,Ic1(1))),...            
            'CC_dynamic_case/Relay','OnOutputValue',num2str(-unifrnd(2.3,Id2(2))),...
            'CC_dynamic_case/Relay','OffOutputValue',num2str(unifrnd(2.3,Ic2(2))),...
            'CC_dynamic_case/Relay1','OnOutputValue',num2str(-unifrnd(2.3,Id3(3))),...
            'CC_dynamic_case/Relay1','OffOutputValue',num2str(unifrnd(2.3,Ic3(3)))...            
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
    
    save(strcat('./data/CC_change_SOC3_6.mat'), 'data', '-v7.3');
end

% F2
Id3=[5.6,3.2,2.3];
Ic3=[4.3,4.3,2.6]; %0,400,800 SOC 20%-80%

Id2=[11.7,6.4,2.3];
Ic2=[4.3,4.3,4.1]; %0,400,800 SOC 1%-40%

Id1=[7.2,4,2.3];
Ic1=[4.3,4.3,3]; %0,400,800 SOC 1%-60%

epoch=1;batch_size=64;

for i=1:epoch
    RUL=[];    
    
    for j=1:batch_size      
        
        in(j) = Simulink.SimulationInput('CC_dynamic_case');
        in(j) = in(j).setBlockParameter(...
            'CC_dynamic_case/Relay2','OnOutputValue',num2str(-unifrnd(2.3,Id1(1))),...
            'CC_dynamic_case/Relay2','OffOutputValue',num2str(unifrnd(2.3,Ic1(1))),...            
            'CC_dynamic_case/Relay','OnOutputValue',num2str(-unifrnd(2.3,Id2(2))),...
            'CC_dynamic_case/Relay','OffOutputValue',num2str(unifrnd(2.3,Ic2(2))),...
            'CC_dynamic_case/Relay1','OnOutputValue',num2str(-unifrnd(2.3,Id3(3))),...
            'CC_dynamic_case/Relay1','OffOutputValue',num2str(unifrnd(2.3,Ic3(3)))...            
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
    
    save(strcat('./data/CC_change_SOC3_6.mat'), 'data', '-v7.3');
end