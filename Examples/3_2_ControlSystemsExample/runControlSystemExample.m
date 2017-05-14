%% Simulation parameters
t2fisSim = readt2fis('IT2_FPID.t2fis');
Ke=1;
Kd=0.5141;
Ka=0.077;
Kb=7.336;
SamplingTime=0.05;

%% System parameters
K=1;
T=1.1;
L=0.3;

open_system('IT2_FPID_Controller.slx')
T2Controller=find_system('IT2_FPID_Controller','name',...
    'Interval Type-2 Fuzzy PID');
T2Controller=[T2Controller{1} '/Interval Type-2 Fuzzy PID'];


%% TR Method -> KM
set_param(T2Controller,'TRtype','1');
sim('IT2_FPID_Controller.slx');
y_KM=y.signals.values;
u_KM=u.signals.values;

%% TR Method -> IASC
set_param(T2Controller,'TRtype','3');
sim('IT2_FPID_Controller.slx');
y_IASC=y.signals.values;
u_IASC=u.signals.values;


%% TR Method -> WM
set_param(T2Controller,'TRtype','6');
sim('IT2_FPID_Controller.slx');
y_WM=y.signals.values;
u_WM=u.signals.values;


%% TR Method -> NT
set_param(T2Controller,'TRtype','7');
sim('IT2_FPID_Controller.slx');
y_NT=y.signals.values;
u_NT=u.signals.values;



%% Reference and time arrays
ref=ref.signals.values;
time=y.time;

%% Plot figures
figure;
plot(time,ref,time,y_KM,time,y_WM,time,y_NT,time,y_IASC);
legend('Reference','IT2-FPID-KM','IT2-FPID-WM','IT2-FPID-NT','IT2-FPID-BMM');

figure;
plot(time,u_KM,time,u_WM,time,u_NT,time,u_IASC);
legend('IT2-FPID-KM','IT2-FPID-WM','IT2-FPID-NT','IT2-FPID-BMM');