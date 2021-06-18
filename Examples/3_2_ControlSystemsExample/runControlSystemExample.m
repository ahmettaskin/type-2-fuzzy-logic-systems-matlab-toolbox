%  IT2-FLS Toolbox is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     IT2-FLS Toolbox is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with IT2-FLS Toolbox.  If not, see <http://www.gnu.org/licenses/>.
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

%% TR Method -> EKM
set_param(T2Controller,'TRtype','2');
sim('IT2_FPID_Controller.slx');
y_EKM=y.signals.values;
u_EKM=u.signals.values;


%% TR Method -> WM
set_param(T2Controller,'TRtype','6');
sim('IT2_FPID_Controller.slx');
y_WM=y.signals.values;
u_WM=u.signals.values;


%% TR Method -> NT
set_param(T2Controller,'TRtype','8');
sim('IT2_FPID_Controller.slx');
y_NT=y.signals.values;
u_NT=u.signals.values;



%% Reference and time arrays
ref=ref.signals.values;
time=y.time;

%% Plot figures
figure;
plot(time,ref,time,y_KM,time,y_EKM,time,y_WM,time,y_NT);
legend('Reference','IT2-FPID-KM','IT2-FPID-EKM','IT2-FPID-WM','IT2-FPID-NT');

% figure;
% plot(time,u_KM,time,u_WM,time,u_NT,time,u_IASC);
% legend('IT2-FPID-KM','IT2-FPID-WM','IT2-FPID-NT','IT2-FPID-IASC');