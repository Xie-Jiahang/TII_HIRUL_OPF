%% get the critical point (con_extreme_point) for feasible region F1 (Id_max,Ic)
clear;clc;sce=3;
RUL_set=24*15;

SOC_max=[98,80,40,60,98,98,60];
SOC_min=[1,20,1,1,40,60,40];

data=struct;
data.Crate=[];

for Neq0=0:50:900
    
    in=Simulink.SimulationInput('CC_2019a');
    in=in.setBlockParameter(...            
    'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
    'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
    'CC_2019a/Relay','OnOutputValue',num2str(-7),...
    'CC_2019a/Relay','OffOutputValue',num2str(2.3),...
    'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(7),...
    'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(2.3),...
    'CC_2019a/Battery','Neq0',num2str(Neq0)...
    );    
    simOut=parsim(in);
    if simOut.tout(end)/3600<RUL_set
        Id=7:-0.1:2.3;
    else
        Id=11.7:-0.1:7;
    end        

for i=1:ceil(numel(Id)/32)
    I_d=Id(32*(i-1)+1:min(32*i,length(Id)));    
    
    %% set I_c as the minimum value to try to extend to the maximum possible I_d
    I_c=2.3;
    for j=1:numel(I_d)
        in(j)=Simulink.SimulationInput('CC_2019a');
        in(j)=in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-I_d(j)),...
        'CC_2019a/Relay','OffOutputValue',num2str(I_c),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(I_d(j)),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(I_c),...
        'CC_2019a/Battery','Neq0',num2str(Neq0)...
        );
    end
    simOut=parsim(in);tmp=[];
    for j=1:numel(I_d)
        tmp=[tmp;simOut(j).tout(end)/3600];        
    end
    idx=find(tmp>=RUL_set);
    if isempty(idx)
        continue        
    else
        I_d=I_d(idx(1));
    end    
    
    %% after getting the maximum possible I_d, search for the corresponding I_c
    Ic=4.3:-0.1:2.3;RUL=[];R=[];
    for j=1:numel(Ic)
        in(j)=Simulink.SimulationInput('CC_2019a');
        in(j)=in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-I_d),...
        'CC_2019a/Relay','OffOutputValue',num2str(Ic(j)),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(I_d),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(Ic(j)),...
        'CC_2019a/Battery','Neq0',num2str(Neq0)...
        );        
    end
    simOut=parsim(in);
    
    for j=1:numel(Ic)
        RUL=[RUL;simOut(j).tout(end)/3600];
        R=[R;simOut(j).battery_Resistance(1)];
    end
    idx=find(RUL>=RUL_set);    
    data.Crate=[data.Crate;Neq0,mean(R),I_d,I_c(idx(1))];
    break
end
save('./data/CC_critical_F1_3.mat','data','-v7.3');
if Ic(idx(1))==2.3 && I_d==2.3
    break
end

end
