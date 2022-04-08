%% get CCCV RUL with RUL constraint
clear;clc;rng(7);
Neq0=[0,400,800];
SOC_max=[60,80,40];
SOC_min=[1,20,1];
Id=[11.3484,11.0747,5.9659];
Ic=[3.4,2.3,2.3];

for j=1:numel(Neq0)
    CV_max=[0,unifrnd(3.55,3.7)];
    
    in(j)=Simulink.SimulationInput('CCCV_BatteryCellSimplified_2019a');
    in(j)=in(j).setBlockParameter(...
    'CCCV_BatteryCellSimplified_2019a/Relay','OnSwitchValue',num2str(SOC_max(j)/100),...
    'CCCV_BatteryCellSimplified_2019a/Relay','OffSwitchValue',num2str(SOC_min(j)/100),...
    'CCCV_BatteryCellSimplified_2019a/Relay','OnOutputValue',num2str(-Id(j)),...
    'CCCV_BatteryCellSimplified_2019a/Relay','OffOutputValue',num2str(Ic(j)),...
    'CCCV_BatteryCellSimplified_2019a/CV_max','Value',num2str(CV_max(2)),...
    'CCCV_BatteryCellSimplified_2019a/Battery','Neq0',num2str(Neq0(j))...
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