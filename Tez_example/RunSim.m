%% Simulation parameters

Ke=1;
Kd=0.5141;
Ka=0.077;
Kb=7.336;
SamplingTime=0.05;

% 
% Nominal System parameters
K=1;
T=1;
L=0.2;

% 
% % Second System parameters
% K=1.3;
% T=1.9;
% L=0.4;


% % Third System parameters
% K=1.1;
% T=1.3;
% L=0.45;

T2Controller=find_system('Tez_test','name',...
    'Interval Type-2 Fuzzy PID');
T2Controller=T2Controller{1};


%% TR Method -> KM
set_param(T2Controller,'TRtype','1');
sim('Tez_test.slx');
y_KM=y.signals.values;
u_KM=u.signals.values;
IAE_KM=IAE(end);
ITAE_KM=ITAE(end);


% 
% %% TR Method -> EKM
% set_param(T2Controller,'TRtype','2');
% sim('Tez_test.slx');
% yEKM=y.signals.values;
% 
% %% TR Method -> IASC
% set_param(T2Controller,'TRtype','3');
% sim('Tez_test.slx');
% yIASC=y.signals.values;
% 
% %% TR Method -> EIASC
% set_param(T2Controller,'TRtype','4');
% sim('Tez_test.slx');
% yEIASC=y.signals.values;
% 
% %% TR Method -> EODS
% set_param(T2Controller,'TRtype','5');
% sim('Tez_test.slx');
% yEODS=y.signals.values;

%% TR Method -> WM
set_param(T2Controller,'TRtype','6');
sim('Tez_test.slx');
y_WM=y.signals.values;
u_WM=u.signals.values;
IAE_WM=IAE(end);
ITAE_WM=ITAE(end);





%% TR Method -> NT
set_param(T2Controller,'TRtype','7');
sim('Tez_test.slx');
y_NT=y.signals.values;
u_NT=u.signals.values;
IAE_NT=IAE(end);
ITAE_NT=ITAE(end);




%% TR Method -> BMM
set_param(T2Controller,'TRtype','8');
sim('Tez_test.slx');
y_BMM=y.signals.values;
u_BMM=u.signals.values;
IAE_BMM=IAE(end);
ITAE_BMM=ITAE(end);

%% Reference and time arrays
ref=ref.signals.values;
time=y.time;

%% Plot figures
figure;
plot(time,ref,time,y_KM,time,y_WM,time,y_NT,time,y_BMM);
legend('Reference','IT2-FPID-KM','IT2-FPID-WM','IT2-FPID-NT','IT2-FPID-BMM');


figure;
plot(time,u_KM,time,u_WM,time,u_NT,time,u_BMM);
legend('IT2-FPID-KM','IT2-FPID-WM','IT2-FPID-NT','IT2-FPID-BMM');


% %% Overshoots
% Overshoot_KM=100*((max(y_KM)-y_KM(end))/y_KM(end));
% Overshoot_WM=100*((max(y_WM)-y_WM(end))/y_WM(end));
% Overshoot_NT=100*((max(y_NT)-y_NT(end))/y_NT(end));
% Overshoot_BMM=100*((max(y_BMM)-y_BMM(end))/y_BMM(end));
% 
% 
% %% Settling Time
% SettlingTime_KM=max(max(find(1.05<y_KM)),max(find(0.95>y_KM)))/20-1;
% SettlingTime_WM=max(max(find(1.05<y_WM)),max(find(0.95>y_WM)))/20-1;
% SettlingTime_NT=max(max(find(1.05<y_NT)),max(find(0.95>y_NT)))/20-1;
% SettlingTime_BMM=max(max(find(1.05<y_BMM)),max(find(0.95>y_BMM)))/20-1;

