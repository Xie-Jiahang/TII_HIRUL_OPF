%% get CCCV RUL under different SOC ranges
% initialization
clear;clc;rng(7);
Id=[0,11.7];Ic=[0,4.3]; % both set to the maximum value

data=struct;
data.CV_max=[];data.SOC_max=[];data.SOC_min=[];
data.RUL={};data.V_max={};data.V_min={};

epoch=20;batch_size=8;

for i=1:epoch
    RUL=[];
    
    for j=1:batch_size
        SOC_max=[0, unifrnd(90-j*30/batch_size,98)];
        data.SOC_max=[data.SOC_max;SOC_max(2)];
        
        CV_max=[0,unifrnd(3.55,3.7)];
        data.CV_max=[data.CV_max;CV_max(2)];
        
        SOC_min=[0,unifrnd(1,10+j*30/batch_size)];
        data.SOC_min=[data.SOC_min;SOC_min(2)];
        
        in(j) = Simulink.SimulationInput('CCCV_BatteryCellSimplified_2019a');
        in(j) = in(j).setBlockParameter(...
            'CCCV_BatteryCellSimplified_2019a/Relay','OnSwitchValue',num2str(SOC_max(2)/100),...
            'CCCV_BatteryCellSimplified_2019a/Relay','OffSwitchValue',num2str(SOC_min(2)/100),...
            'CCCV_BatteryCellSimplified_2019a/Relay','OnOutputValue',num2str(-Id(2)),...
            'CCCV_BatteryCellSimplified_2019a/Relay','OffOutputValue',num2str(Ic(2)),...
            'CCCV_BatteryCellSimplified_2019a/CV_max','Value',num2str(CV_max(2))...
            );
    end
    simOut=parsim(in);
    
    for j=1:batch_size
        try
            RUL=[RUL;simOut(j).tout(end)/3600];
            [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
            data.V_max(i,j)={V_max};
            data.V_min(i,j)={V_min};
        catch
            continue
        end
    end
    data.RUL(i)={RUL};
    save('./data/CCCV_RUL_SOCrange.mat', 'data', '-v7.3');
end