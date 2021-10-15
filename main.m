%% Example driver script for simulating "antithetic" model.
% This file was automatically generated by OneModel.
% Any changes you make to it will be overwritten the next time
% the file is generated.

clear all;
close all;

% Init model.
m = multiscale();

% Solver options.
opt = odeset('AbsTol',1e-8,'RelTol',1e-8);
opt = odeset(opt,'Mass',m.M);

% Simulation time span.
t_steady = 100000;
tspan = [0 t_steady];

p = m.p;
p.cell__z1__omega = 0;
p.cell__z2__omega = 0;
p.cell__z12__omega = 0;

[t,x] = ode15s(@(t,x) m.ode(t,x,p),tspan,m.x0,opt);
out_0 = m.simout2struct(t,x,p);

[t,x] = ode15s(@(t,x) m.ode(t,x,p),[0 1000],x(end,:),opt);
out_1 = m.simout2struct(t,x,p);

tspan = [1000 m.opts.t_end+1000];
[t,x] = ode15s(@(t,x) m.ode(t,x,m.p),tspan,x(end,:),opt);
out_2 = m.simout2struct(t,x,m.p);

out = concatStruct(out_1, out_2);

p = m.p;
p.cell__nu = p.cell__nu*0.95;
tspan = [m.opts.t_end+1000 m.opts.t_end+3000];
[t,x] = ode15s(@(t,x) m.ode(t,x,p),tspan,x(end,:),opt);
out_3 = m.simout2struct(t,x,p);

out = concatStruct(out, out_3);

% Plot result.
figure(1);

subplot(2,2,1);

hold on;
plot(out.t, out.cell__x__m);
plot(out.t, out.cell__ref);

grid on;
title('Output');
legend('x');
ylim([0 +inf])

subplot(2,2,2);

hold on;
plot(out.t, out.cell__mu);

grid on;
title('Growth rate');
legend('\mu');
ylim([0 +inf])

subplot(2,2,3);

hold on;
plot(out.t, out.cell__z1__m);
plot(out.t, out.cell__z2__m);
plot(out.t, out.cell__z12__m);

grid on;
title('Control action');
legend('z1','z2','z12');
ylim([0 +inf])

subplot(2,2,4);

hold on;
plot(out.t, out.cell__p_r__m);
plot(out.t, out.cell__p_nr__m)
plot(out.t, out.cell__m_h);
plot(out.t, out.cell__m_p);

grid on;
title('ribo and non-ribo');
legend('r','nr');
ylim([0 +inf])

figure(2);

controller = out.cell__z1__m + out.cell__z2__m + out.cell__z12__m; 

mass = [
    out.cell__p_r__m out.cell__p_nr__m out.cell__x__m controller
    ];

subplot(3,1,1);

area(out.t, mass);
ylim([0 +inf])
legend('ribo','ron-ribo','x','controller');

subplot(3,1,2);

area(out.t, mass./sum(mass')');
ylim([0 +inf])
legend('ribo','ron-ribo','x','controller');

subplot(3,1,3);

plot(out.t, 100*(controller + out.cell__x__m)./sum(mass')');
ylim([0 +inf])



figure(3);

controller = out.cell__z1__J + out.cell__z2__J + out.cell__z12__J; 

mass = [
    out.cell__p_r__N.*out.cell__p_r__J out.cell__p_nr__N.*out.cell__p_nr__J out.cell__x__J controller
    ];

area(out.t, mass);
ylim([0 +inf]);
legend('ribo','ron-ribo','x','controller');


