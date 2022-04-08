%% get OPF result with&without RUL constraint to compare based on scaled up data; draw results
mpopt=mpoption('out.all',0);
data=case39_original;
f1=runopf(data,mpopt);
obj1=f1.f;
success1=f1.success;
V1=f1.bus(36:38,8);
P1=f1.gen(7:9,2);

data=case39_HI;
pu_V_full=1.06;pu_V_empty=0.94;pu_P_max=999;
V_full=3.748;V_empty=2.475; % fully charged voltage & cut-off voltage
I_max=11.7;
P_max=V_full*I_max;
coeff_V=(pu_V_full-pu_V_empty)/(V_full-V_empty);
coeff_P=pu_P_max/P_max;

load('./data/CC_V_bounds.mat');load('./data/CC_P_bounds.mat');

B1=[1,2];B2=[3,4];B3=[5,6];

Vu=[];Vl=[];Pu=[];
for i=1:length(V_bounds)
    Vu=[Vu;pu_V_full-(V_full-V_bounds(i,1))*coeff_V];
    Vl=[Vl;pu_V_empty+(V_bounds(i,2)-V_empty)*coeff_V];
    Pu=[Pu;P_bounds(i,1)*coeff_P];
end

combination=[1,3,5;1,3,6;1,4,5;1,4,6;2,3,5;2,3,6;2,4,5;2,4,6];obj=[];success=[];V=[];P=[];
for i=1:length(combination)
    data.bus(36:38,end-1:end)=[Vu(combination(i,:)),Vl(combination(i,:))];
    data.gen(7:9,9)=Pu(combination(i,:));
    
    f2=runopf(data,mpopt);
    obj=[obj;f2.f];
    success=[success;f2.success];
    V=[V,f2.bus(36:38,8)];
    P=[P,f2.gen(7:9,2)];
end

obj=obj(find(success==1));
[val,idx]=min(obj);
data.bus(36:38,end-1:end)=[Vu(combination(idx,:)),Vl(combination(idx,:))];
data.gen(7:9,9)=Pu(combination(idx,:));
f2=runopf(data,mpopt);

opt_V_original=(f1.bus(36:38,8)-pu_V_empty)/coeff_V+V_empty;
opt_P_original=f1.gen(7:9,2)/coeff_P;
Id_original=opt_P_original./opt_V_original;

opt_V=(f2.bus(36:38,8)-pu_V_empty)/coeff_V+V_empty;
opt_P=f2.gen(7:9,2)/coeff_P;
Id=opt_P./opt_V;

figure
subplot(2,1,1);
plot(1:39,f1.bus(:,8),'--bo');
hold on
plot(1:39,f2.bus(:,8),'--ro');
grid on
xlabel('Bus');
ylabel('Volatge (p.u.)');
set(gca,'XTick',0:10:40);
set(gca,'YTick',0.96:0.02:1.06);
plot(1:39,f1.bus(:,8),'--bo','MarkerIndices',[36,37,38],'MarkerFaceColor','b','MarkerSize',8);
plot(1:39,f2.bus(:,8),'--ro','MarkerIndices',[36,37,38],'MarkerFaceColor','r','MarkerSize',8);
legend('Case 1','Case 2','Location','best');
% title('Bus voltage','position',[20,0.98]);

subplot(2,1,2);
plot(1:10,f1.gen(:,2),'--b^');
hold on
plot(1:10,f2.gen(:,2),'--rp');
grid on
xlabel('Generation source');
ylabel('Active power (kW)');
plot(1:10,f1.gen(:,2),'--b^','MarkerIndices',[7,8,9],'MarkerFaceColor','b','MarkerSize',8);
plot(1:10,f2.gen(:,2),'--rp','MarkerIndices',[7,8,9],'MarkerFaceColor','r','MarkerSize',8);
legend('Case 1','Case 2','Location','best');
% title('Active power generation','position',[5.5,220]);
% savefig('./image/39_bus_CC.fig');
