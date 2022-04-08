%% get CC RUL with RUL constraint
clear;clc;
Neq0=[0,400,800];
SOC_max=[60,80,40];
SOC_min=[1,20,1];
Id=[11.3617,10.6324,5.8710];
Ic=[3.4,2.3,2.3];

for j=1:numel(Neq0)
        in(j)=Simulink.SimulationInput('CC_2019a');
        in(j)=in(j).setBlockParameter(...
        'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(j)/100),...
        'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(j)/100),...
        'CC_2019a/Relay','OnOutputValue',num2str(-Id(j)),...
        'CC_2019a/Relay','OffOutputValue',num2str(Ic(j)),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(Id(j)),...
        'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(Ic(j)),...
        'CC_2019a/Battery','Neq0',num2str(Neq0(j))...
        );
end
simOut=parsim(in);RUL=[];

for j=1:numel(Neq0)
    try
        RUL=[RUL;simOut(j).tout(end)/3600];
    catch
        continue
    end
end