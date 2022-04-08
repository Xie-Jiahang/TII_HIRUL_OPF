%% get the mean boundary voltage values
V_bounds=[];
for sce=2:4
    load(strcat('../data/CC_VI_regionb',num2str(sce),'.mat'),'data');
    Vl=mean(data.Ic.Vmin);
    load(strcat('../data/CC_VI_regionc',num2str(sce),'.mat'),'data');
    Vu=mean(data.Id.Vmax);
    V_bounds=[V_bounds;Vu,Vl];
end
