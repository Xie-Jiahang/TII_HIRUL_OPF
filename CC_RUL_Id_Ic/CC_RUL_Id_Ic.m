%% get CC RUL & Id, Ic data under different SOC ranges/scenarios
% initialization
clear;clc;
SOC_max=[98,80,40,60,98,98,60];
SOC_min=[1,20,1,1,40,60,40];

for sce=2:numel(SOC_max)
    
epoch=20;batch_size=8;
Id=linspace(11.7,2.3,20);
Ic=linspace(4.3,2.3,8);

data=struct;
data.RUL={};data.V_max={};data.V_min={};data.P={};
% data.SOC={};

for i=1:epoch
    I_d=Id(i);
    RUL=[];
    
    for j=1:batch_size
        I_c=Ic(j);
                        
        in(j) = Simulink.SimulationInput('CC_2019a');
        in(j) = in(j).setBlockParameter(...
            'CC_2019a/Relay','OnSwitchValue',num2str(SOC_max(sce)/100),...
            'CC_2019a/Relay','OffSwitchValue',num2str(SOC_min(sce)/100),...
            'CC_2019a/Relay','OnOutputValue',num2str(-I_d),...
            'CC_2019a/Relay','OffOutputValue',num2str(I_c),...
            'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_discharge','Value',num2str(I_d),...
            'CC_2019a/Battery/Model/Aging Model/Max. Number of Cycles Calculation Block/I_charge','Value',num2str(I_c)...
            );                                                
    end
    simOut=parsim(in);
    
    for j=1:batch_size
        try
            RUL=[RUL;simOut(j).tout(end)/3600];
            [V_max,V_min]=get_Vrange(simOut(j).battery_Voltage);
            data.V_max(i,j)={V_max};
            data.V_min(i,j)={V_min};
            
            [P_c_mean,P_c_max,P_d_mean,P_d_max]=get_Prange(simOut(j).battery_Power);
            data.P(i,j)={[P_c_mean,P_c_max,P_d_mean,P_d_max]};
%             data.SOC(epoch,t)={simOut(t).battery_SOC};
        catch
            continue
        end
    end
    data.RUL(i)={RUL};
    save(strcat('./data/CC_RUL_Id_Ic_',num2str(sce),'.mat'), 'data', '-v7.3');
end

end
% mailTome('CC RUL_I is done','CC RUL_I is done');