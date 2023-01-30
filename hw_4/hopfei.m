%% 参数初始化 start_t是t的初始值 end_t是t的结束值
%ve0是ve初值;vi0是vi初值
start_t=0;end_t=500;ve0=1;vi0=1;
%He=10:0.1:20;
%% 使用ode45方法计算微分方程组func的数值解
%func是带有方程组的函数 
%[start_t end_t]是自变量范围
%[ve0,vi0]是方程初值
%t是自变量的数组，Rvw是对应的因变量的数值。Rvw(:,1)=ve;Rvw(:,2)=vi;
[t,Rvw]=ode45(@func,[start_t,end_t],[ve0;vi0]);
%% 组合自变量和因变量。TRvw(:,1)=t;TRvw(:,2)=ve;TRvw(:,3)=vi;
TRvw=[t,Rvw];
%% 绘制自变量-因变量图像.figure1是ve-t,figure2是vi-t
plot(t,Rvw(:,1),'-',t,Rvw(:,2),'-')
title('v_E/v_I变化图像');
xlabel('time');
axis([t(1) t(end) 0 500]);
ylabel('v_E/v_I');
axis([Rvw(1) Rvw(end) -20 20]);
legend('v_E','v_I');

function dRvw=func(t,Rvw)
%% 函数功能：为ode45提供微分方程
%输入：t:时间序列; Rvw:因变量,Rvw(1)代表ve,Rvw(2)代表vi
%输出：dRvw:因变量的一阶微分,dRvw(1)代表dve,dRvw(2)代表dvi
%% 初始化因变量的一阶微分，2×1的向量

 mee = 3.5; mei = 2.5;He=15;
 mie = 2.5; mii = 1; Hi = 10;
 taue = 1;taui=2.1;
 
dRvw=zeros(2,1);

beat0 = @(x) max([x,0]);

dRvw(1)=(-Rvw(1)+beat0(mee*Rvw(1)-mei*Rvw(2)+He))/taue;
dRvw(2)=(-Rvw(2)+beat0(mie*Rvw(1)-mii*Rvw(2)+Hi))/taui;
end