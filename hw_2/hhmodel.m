%% Basic Hodgkin-Huxley Implementation
% Equations from Hodgkin, Huxley, J. Physiol (1952) 117, 500-544

clear;
figure(1);clf;

dt = 0.0001;
t = 0:dt:300;
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


tSTIM_START = 0;
tSTIM_DUR = 0;
STIM_STRENGTH = 0;

% DEFINE MISC

inRange = @(x,a,b) (x>=a) & (x<b);


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
    Istim = 150;
    if inRange( t(i) , tSTIM_START , tSTIM_START+tSTIM_DUR)
        Istim = STIM_STRENGTH;
    end

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

% plot the results
plot(t,v);
axis([t(1) t(end) -20 120]);
xlabel('time (ms)');
ylabel('membrane voltage (mV)');
