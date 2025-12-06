
%{
% Contributors: Kendrick Boardman, Ian Oden
% Course number: ASEN 3801
% File name: lab1Main
% Created: 01/17/24
clc; clear; close all;
%function handles
f = @(t,x) [(-9*x(1))+x(3);(4*x(1)*x(2)*x(3))-(x(2).^2);(2*x(1))-x(2)-(2*x(4));(x(2)*x(3))-(x(3)^2)-(3*x(4)^3)];
%initial conditions
ititCond = [1 1 1 1];
% w0 = 2
% x0 = 4
% y0 = 6
% z0 = 3
tinterval = [0 20];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t,sol]= ode45(f,tinterval,ititCond,opts);
size = length(t);
%% plotting the values from ode45

figure()
title("analysis of the dynamical system governing equations")
subplot(4,1,1)
plot(t,sol(:,1));
xlabel("Nondimensional Time ")
ylabel("w")
subplot(4,1,2)
plot(t,sol(:,2));
xlabel("Nondimensional Time ")
ylabel("x")
subplot(4,1,3)
plot(t,sol(:,3))
xlabel("Nondimensional Time ")
ylabel("y")
subplot(4,1,4)
plot(t,sol(:,4))
xlabel("Nondimensional Time ")
ylabel("z")

%% question 1 part b
RefTable = zeros(4,5);
tol = [1e-2,1e-4,1e-6,1e-8,1e-10,1e-12];
opts = odeset('RelTol',tol(1), 'AbsTol',tol(1));
[t2,sol2] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(2), 'AbsTol',tol(2));
[t4,sol4] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(3), 'AbsTol',tol(3));
[t6,sol6] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(4), 'AbsTol',tol(4));
[t8,sol8] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(5), 'AbsTol',tol(5));
[t10,sol10] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(6), 'AbsTol',tol(6));
[tRef,solRef] = ode45(f,tinterval,ititCond,opts);
%% val - val rel for x, y, z
RefTable(:,1) = abs(sol2(end,:) - solRef(end,:));    %% 10^-2
RefTable(:,2) = abs(sol4(end,:) - solRef(end,:));    %% 10^-4
RefTable(:,3) = abs(sol6(end,:) - solRef(end,:));    %% 10^-6
RefTable(:,4) = abs(sol8(end,:) - solRef(end,:));    %% 10^-8
RefTable(:,5) = abs(sol10(end,:) - solRef(end,:));    %% 10^-10
RefTable;
%% Question 2
% a

% b
boulderDensity = stdatmo(1655); %kg/m^3
rho = boulderDensity;
Cd = 0.6;
d = 0.02; %m
A = pi*(d/2)^2;
m = 0.05; %kg
g = 9.81;
wind_vel = [0,0,0];
inCond = [0,0,0,0,20,-20];
tInt = [0,20];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);
[t,x]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel),tInt,inCond,opts);

%c

figure(2)
plot3(x(:,1),x(:,2),x(:,3))
set(gca, 'ZDir','reverse')
xlabel("Distance Traveled North (m)")
ylabel("Distance Traveled East (m)")
zlabel("Distance Traveled Down (m)")
title("Trajectory of Body")

%d
%%%%%%%how to test lots of different windspeeds - different speeds and
%%%%%%%directions
wind_vel = zeros(11,3);
wind_vel(:,1) = linspace(0,100,11)';
windOffsetHoriz = zeros(11,1);
windOffsetDist = zeros(11,1);
WOHperMS = zeros(11,1);
WODperMS = zeros(11,1);
for i = 2:11
   opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);
   [tBase,xBase]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel(1,:)),tInt,inCond,opts);
   [t,x]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel(i,:)),tInt,inCond,opts);
   windOffsetHoriz(i,1) = x(end,1) - x(1,1);
   windOffsetDist(i,1) = sqrt((x(end,1) - x(1,1)).^2+ (x(end,2) - x(1,2)).^2) - sqrt((xBase(end,1) - xBase(1,1)).^2+ (xBase(end,2) - xBase(1,2)).^2);
  
   WOHperMS(i,1) = windOffsetHoriz(i,1)/norm(wind_vel(i,:));  % wind offset in the +x direction per m/s of wind speed
   WODperMS(i,1) = windOffsetDist(i,1)/norm(wind_vel(i,:));    % wind offset on the total distance traveled per m/s of wind speed
end
% 
% part 1
figure(3)
hold on
title("Horizontal Offsets due to Wind in Inertial North Direction")
xlabel("Windspeed in the North Direction (m/s)")
yyaxis left
plot(wind_vel(1:11,1), windOffsetHoriz(1:11))
ylabel("Displacement North (m)")
yyaxis right
plot(wind_vel(1:11,1), WOHperMS(1:11))
ylabel("Displacement per Windspeed (s)")
hold off
mean(WOHperMS)
% note in the north south orientation only the absolute value of the wind
% matters because negative or south wind will give the same displacement as
% the corresponding positive or north
% part 2
figure(4)
hold on
title("Distance Offsets due to Wind in Inertial North Direction")
xlabel("Windspeed in the North Direction (m/s)")
yyaxis left
plot(wind_vel(1:11,1), windOffsetDist(1:11))
ylabel("Change in Distance before Landing (m)")
yyaxis right
plot(wind_vel(1:11,1), WODperMS(1:11))
ylabel("Change in Distance per Windspeed (s)")
hold off
mean(WODperMS)
%%%

wind_vel = [5,0,0];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);
[t,x1]= ode45(@(t,x1) objectEOM(t,x1,rho,Cd,A,m,g,wind_vel),tInt,inCond,opts);
xSize = length(x);
x1Size = length(x1);
WindOffsetHorizontal = x1(x1Size,1) - x1(1,1);
WindOffsetDistance = sqrt((x1(x1Size,1) - x1(1,1)).^2+ (x1(x1Size,2) - x1(1,2)).^2) - sqrt((x(xSize,1) - x(1,1)).^2+ (x(xSize,2) - x(1,2)).^2);
WOHperMS1 = WindOffsetHorizontal/norm(wind_vel);  % wind offset in the +x direction per m/s of wind speed
WODperMS1 = WindOffsetDistance/norm(wind_vel);    % wind offset on the total distance traveled per m/s of wind speed
wind_vel = [0,-5,0];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);
[t,x2]= ode45(@(t,x2) objectEOM(t,x2,rho,Cd,A,m,g,wind_vel),tInt,inCond,opts);
x2Size = length(x2);
WindOffsetHorizontal = x2(x2Size,1) - x2(1,1);
WindOffsetDistance = sqrt((x2(x2Size,1) - x2(1,1)).^2+ (x2(x2Size,2) - x2(1,2)).^2) - sqrt((x(xSize,1) - x(1,1)).^2+ (x(xSize,2) - x(1,2)).^2);
WOHperMS2 = WindOffsetHorizontal/norm(wind_vel);  % wind offset in the +x direction per m/s of wind speed
WODperMS2 = WindOffsetDistance/norm(wind_vel);    % wind offset on the total distance traveled per m/s of wind speed



%e

Cd = 0.6;
d = 0.02; %m
A = pi*(d/2)^2;
m = 0.05; %kg
g = 9.81;
inCond = [0,0,0,0,20,-20];
tInt = [0,1000];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);


alt = linspace(0,2300,10);
varyingwind = linspace(-50,50,100);
figure()
hold on
distance = zeros(length(alt),length(varyingwind));

for j = 1:length(alt)
rho = stdatmo(alt(j));
for k = 1:length(varyingwind)
    wind_vel = [varyingwind(k),0,0];
    [t,x]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel),tInt,inCond,opts);
    distance(j,k)= sqrt((x(end,1)^2)+(x(end,2)^2)+(x(end,3)^2));

end
end

plot(varyingwind,distance);

title("Change in distance due to wind and altitude.")
xlabel("wind speed")
ylabel("distance")
legend(string(alt)+"m","Location","south");

hold off

figure()
for w =1:length(alt)
mindist(w) = min(distance(w,:));
end
plot(alt,mindist);
xlabel("altitude");
ylabel("minimum distance");
title("minimum distance per altitude");



% part f

vel = sqrt(20^2 + 20^2);
ken = 0.5 * m * vel^2;
boulderDensity = stdatmo(1655); %kg/m^3
rho = boulderDensity;
mass = linspace(0.05,0.15,10);
dist1 = zeros(length(mass),length(varyingwind));
for y = 1:length(mass)
    newvel = sqrt((2*ken)./mass(y));
    newvel = newvel*cosd(45);
    invel = [0 0 0 0 newvel (-1*newvel)];
    for k = 1:length(varyingwind)
        wind_vel = [varyingwind(k),0,0];
        [t,x1]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,mass(y),g,wind_vel),tInt,invel,opts);
        dist1(y,k)= sqrt((x1(end,1)^2)+(x1(end,2)^2)+(x1(end,3)^2));
    end
    [t,x2]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,mass(y),g,[0 0 0]),tInt,invel,opts);
    dist2(y)= sqrt((x2(end,1)^2)+(x2(end,2)^2)+(x2(end,3)^2));
    
end
figure()
plot(varyingwind,dist1);
legend(string(mass)+"kg");
xlabel("windspeed (m/s)");
ylabel("distance (m)")

figure()
plot(mass,dist2);
xlabel("mass (kg)")
ylabel("distance (m)")






function [value, isterminal, direction] = myEvent(t, x)
value      = (x(3) > 0);
isterminal = 1;   % Stop the integration
direction  = 0;
end

%}

% Contributors: Kendrick Boardman, Ian Oden
% Course number: ASEN 3801
% File name: lab1Main
% Created: 01/17/24
clc; clear; close all;
%function handles
f = @(t,x) [(-9*x(1))+x(3);(4*x(1)*x(2)*x(3))-(x(2).^2);(2*x(1))-x(2)-(2*x(4));(x(2)*x(3))-(x(3)^2)-(3*x(4)^3)];
%initial conditions
ititCond = [1 1 1 1];
% w0 = 2
% x0 = 4
% y0 = 6
% z0 = 3
tinterval = [0 20];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t,sol]= ode45(f,tinterval,ititCond,opts);
size = length(t);
%% plotting the values from ode45

figure()
title("analysis of the dynamical system governing equations")
subplot(4,1,1)
plot(t,sol(:,1));
xlabel("Nondimensional Time ")
ylabel("w")
subplot(4,1,2)
plot(t,sol(:,2));
xlabel("Nondimensional Time ")
ylabel("x")
subplot(4,1,3)
plot(t,sol(:,3))
xlabel("Nondimensional Time ")
ylabel("y")
subplot(4,1,4)
plot(t,sol(:,4))
xlabel("Nondimensional Time ")
ylabel("z")

%% question 1 part b
RefTable = zeros(4,5);
tol = [1e-2,1e-4,1e-6,1e-8,1e-10,1e-12];
opts = odeset('RelTol',tol(1), 'AbsTol',tol(1));
[t2,sol2] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(2), 'AbsTol',tol(2));
[t4,sol4] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(3), 'AbsTol',tol(3));
[t6,sol6] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(4), 'AbsTol',tol(4));
[t8,sol8] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(5), 'AbsTol',tol(5));
[t10,sol10] = ode45(f,tinterval,ititCond,opts);
opts = odeset('RelTol',tol(6), 'AbsTol',tol(6));
[tRef,solRef] = ode45(f,tinterval,ititCond,opts);
%% val - val rel for x, y, z
RefTable(:,1) = abs(sol2(end,:) - solRef(end,:));    %% 10^-2
RefTable(:,2) = abs(sol4(end,:) - solRef(end,:));    %% 10^-4
RefTable(:,3) = abs(sol6(end,:) - solRef(end,:));    %% 10^-6
RefTable(:,4) = abs(sol8(end,:) - solRef(end,:));    %% 10^-8
RefTable(:,5) = abs(sol10(end,:) - solRef(end,:));    %% 10^-10
RefTable;
%% Question 2
% a

% b
boulderDensity = stdatmo(1655); %kg/m^3
rho = boulderDensity;
Cd = 0.6;
d = 0.02; %m
A = pi*(d/2)^2;
m = 0.05; %kg
g = 9.81;
wind_vel = [0,0,0];
inCond = [0,0,0,0,20,-20];
tInt = [0,20]; %time interval
opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent); %tolerances
[t,x]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel),tInt,inCond,opts);

%c
line = [linspace(0,0,11);linspace(0,x(end,2),11);linspace(0,0,11)]';
%line along x axis
figure(2)
plot3(x(:,1),x(:,2),x(:,3))
hold on
plot3(line(:,1),line(:,2),line(:,3),':')
set(gca, 'ZDir','reverse')
xlabel("Distance Traveled North (m)")
ylabel("Distance Traveled East (m)")
zlabel("Distance Traveled Down (m)")
title("Trajectory of Body")
hold off

%d
%%%%%%%how to test lots of different windspeeds - different speeds and
%%%%%%%directions
wind_vel = zeros(11,3);
wind_vel(:,1) = linspace(0,100,11)'; 
%setting up matrix with all tested windspeed
windOffsetHoriz = zeros(11,1);
windOffsetDist = zeros(11,1);
WOHperMS = zeros(11,1);
WODperMS = zeros(11,1);

for i = 2:11 %loop through ode for each wind speed
   opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);
   [tBase,xBase]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel(1,:)),tInt,inCond,opts);
   [t,x]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel(i,:)),tInt,inCond,opts);
   windOffsetHoriz(i,1) = x(end,1) - x(1,1);
   windOffsetDist(i,1) = sqrt((x(end,1) - x(1,1)).^2+ (x(end,2) - x(1,2)).^2) - sqrt((xBase(end,1) - xBase(1,1)).^2+ (xBase(end,2) - xBase(1,2)).^2);
  
   WOHperMS(i,1) = windOffsetHoriz(i,1)/norm(wind_vel(i,:));  % wind offset in the +x direction per m/s of wind speed
   WODperMS(i,1) = windOffsetDist(i,1)/norm(wind_vel(i,:));    % wind offset on the total distance traveled per m/s of wind speed
end
% 
% part 1
figure(3)
hold on
title("Horizontal Offsets due to Wind in Inertial North Direction")
xlabel("Windspeed in the North Direction (m/s)")
yyaxis left
plot(wind_vel(1:11,1), windOffsetHoriz(1:11))
ylabel("Displacement North (m)")
yyaxis right
plot(wind_vel(1:11,1), WOHperMS(1:11))
ylabel("Displacement per Windspeed (s)")
hold off
mean(WOHperMS)
% note in the north south orientation only the absolute value of the wind
% matters because negative or south wind will give the same displacement as
% the corresponding positive or north

% part 2
figure(4)
hold on
title("Distance Offsets due to Wind in Inertial North Direction")
xlabel("Windspeed in the North Direction (m/s)")
yyaxis left
plot(wind_vel(1:11,1), windOffsetDist(1:11))
ylabel("Change in Distance before Landing (m)")
yyaxis right
plot(wind_vel(1:11,1), WODperMS(1:11))
ylabel("Change in Distance per Windspeed (s)")
hold off
mean(WODperMS)
%%%



%e

Cd = 0.6;
d = 0.02; %m
A = pi*(d/2)^2;
m = 0.05; %kg
g = 9.81;
inCond = [0,0,0,0,20,-20];
tInt = [0,1000];
opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events', @myEvent);


alt = linspace(0,2300,10);
varyingwind = linspace(-50,50,100);
figure()
hold on
distance = zeros(length(alt),length(varyingwind));

for j = 1:length(alt)
rho = stdatmo(alt(j));
for k = 1:length(varyingwind)
    wind_vel = [varyingwind(k),0,0];
    [t,x]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel),tInt,inCond,opts);
    distance(j,k)= sqrt((x(end,1)^2)+(x(end,2)^2)+(x(end,3)^2));

end
end

plot(varyingwind,distance);

title("Change in distance due to wind and altitude.")
xlabel("wind speed")
ylabel("distance")
legend(string(alt)+"m","Location","south");

hold off

figure()
for w =1:length(alt)
mindist(w) = min(distance(w,:));
end
plot(alt,mindist);
xlabel("altitude");
ylabel("minimum distance");
title("minimum distance per altitude");



% part f

vel = sqrt(20^2 + 20^2);
ken = 0.5 * m * vel^2;
boulderDensity = stdatmo(1655); %kg/m^3
rho = boulderDensity;
mass = linspace(0.001,0.15,10);
dist1 = zeros(length(mass),length(varyingwind));
for y = 1:length(mass)
    newvel = sqrt((2*ken)./mass(y));
    newvel = newvel*cosd(45);
    invel = [0 0 0 0 newvel (-1*newvel)];
    for k = 1:length(varyingwind)
        wind_vel = [varyingwind(k),0,0];
        [t,x1]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,mass(y),g,wind_vel),tInt,invel,opts);
        dist1(y,k)= sqrt((x1(end,1)^2)+(x1(end,2)^2)+(x1(end,3)^2));
    end
    [t,x2]= ode45(@(t,x) objectEOM(t,x,rho,Cd,A,mass(y),g,[0 0 0]),tInt,invel,opts);
    dist2(y)= sqrt((x2(end,1)^2)+(x2(end,2)^2)+(x2(end,3)^2));
    
end
figure()
plot(varyingwind,dist1);
legend(string(mass)+"kg");
xlabel("windspeed (m/s)");
ylabel("distance (m)")
title("varying mass and wind speed vs distance")

figure()
plot(mass,dist2);
xlabel("mass (kg)")
ylabel("distance (m)")
title("distance vs mass")





function [value, isterminal, direction] = myEvent(t, x)
value      = (x(3) > 0);
isterminal = 1;   % Stop the integration
direction  = 0;
end





