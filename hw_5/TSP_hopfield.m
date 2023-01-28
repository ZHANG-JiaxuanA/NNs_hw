%% 利用Hopfield神经网络实现一个TSP问题的求解

function TSP_hopfield()
clear all;
close all;

% step 1
A=1.5;
D=1;
u0=0.02;
step=0.01;

% step 2
N=8;
citys=load('8.txt');    % 8个城市的横纵坐标
Initial_Length=Initial_RouteLength(citys);        % 计算初始路径长度

DistanceCity=dist(citys,citys');

% step 3 初始化
u=2*rand(N,N)-1;    % 产生随机数
U=0.5*u0*log(N-1)+u;
V=(1+tanh(U/u0))/2;

for k=1:1:2000  % 迭代步数2000
    times(k)=k;
    
%     step 4
    dU=DeltaU(V,DistanceCity,A,D);
    
%     step 5
    U=U+dU*step;
    
%     step 6 利用sigmoid函数计算
    V=(1+tanh(U/u0))/2;
    
%     step 7 计算能量函数
    E=Energy(V,DistanceCity,A,D);
    Ep(k)=E;
    
%     step 8 检查路径合法性
    [V1,CheckR]=RouteCheck(V);
end

% step 9
if (CheckR==0)
    Final_E=Energy(V1,DistanceCity,A,D);
    Final_Length=Final_RouteLength(V1,citys);       % 计算最终路径长度
    disp('迭代次数');k
    disp('寻优路径矩阵：');V1
    disp('最优能量函数：');Final_E
    disp('初始路程：');Initial_Length
    disp('最短路程：');Final_Length
    PlotR(V1,citys);    % 寻优路径作图
else
    disp('寻优路径无效');
end



figure(2);
plot(times,Ep,'r');
title('Energy Function Change');
xlabel('k');
ylabel('E');

