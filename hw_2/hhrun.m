function [mm] = hhrun(Istim)   
%   This function simulates the Hodgkin-Huxley model for user specified input
%   current.
%  
%   hhrun(I,tspan,V,m,h,n,Plot) function simulates the Hodgkin-Huxley model 
%   for the squid giant axon for user specified values of the current input,
%   timespan, initial values of the variables and the solution method. As
%   output it plots voltage (membrane potential) time series and also the 
%   plots between three variables V vs. m,n and h. It uses the forward
%   euler method for solving the ODEs. Enter 1 in the plot field if you
%   want time series and V vs gating variable plots, 0 otherwise.
%   
%   Usage:
%
%   Example 1 -
%   
%   hhrun(0.1, 500, -65, 0.5, 0.06, 0.5,1)
%   where,
%   Input current is 0.1 mA
%   Timespan is 500 ms
%  -65 0.5 0.06 0.5 are the initial values of V,m,h and n respectively
%   Will display the voltage time series and limit cycle plots
%
%   Example 2 -
%   [V,m,h,n,t] = hhrun(0.08, 200, -65, 0.4, 0.2, 0.5,0);
%   V,m,h,n and t vectors will hold the respective values
%   There will be no plots since plot field is 0 
%   plot(t,V) will generate the time series plot

  
 
  dt = 0.001;
  t = 0:dt:500;
% Nernst Potentials

  Ena = 115; Ek = -12; El = 10.599;

% Maximum Conductances
  gna = 120; gk = 36; gl = 0.3;

% Membrane Capacitance
  C = 1;


% 离子通道打开
  an = @(u) (0.1-0.01*u)/(exp(1-0.1*u)-1);
  am = @(u) (2.5-0.1*u)/(exp(2.5-0.1*u)-1);
  ah = @(u) 0.07*exp(-u/20);

% 离子通道关闭
  bn = @(u) 0.125*exp(-u/80);
  bm = @(u) 4*exp(-u/18);
  bh = @(u) 1/(exp(3-0.1*u)+1);

% DEFINE FORMULAE FOR STEADY STATE GATE ACTIVATIONS

  m_inf = @(u) am(u) / ( am(u) + bm(u) );
  n_inf = @(u) an(u) / ( an(u) + bn(u) );
   h_inf = @(u) ah(u) / ( ah(u) + bh(u) );


% INITIALIZE STATE VARIABLES


  m = 0*t + m_inf(0);
  n = 0*t + n_inf(0);
  h = 0*t + h_inf(0);
  v = 0*t;

% DEFINE STIMULUS STRENGTH, DURATION, & DELAY


 

% DEFINE MISC

  


% MAIN LOOP

  for i = 1:length(t)-1
    
    % extract membrane voltage
      u = v(i);

    % solve for membrane currents
      Ik  = gk  * n(i)^4      * (u - Ek);
      Ina = gna * m(i)^3*h(i) * (u - Ena);
      Il  = gl  *               (u - El);   
      Imem = Ik + Ina + Il;
    
    % determine stimulus current, if any
      Istim = Istim;
      

    % define the state variable derivatives
      dv = (Istim - Imem)/C;
      dm = am(u) * (1-m(i)) - bm(u) * m(i);
      dh = ah(u) * (1-h(i)) - bh(u) * h(i);
      dn = an(u) * (1-n(i)) - bn(u) * n(i);
    
    % use forward euler to increment the state variables
      v(i+1) = v(i) + dv*dt;
      m(i+1) = m(i) + dm*dt;
      h(i+1) = h(i) + dh*dt;
      n(i+1) = n(i) + dn*dt;
    
  end

  v = v(400/dt:length(t));
  mm = [min(v),max(v)];

end
