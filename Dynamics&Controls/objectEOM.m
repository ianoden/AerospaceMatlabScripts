
function [xdot] = objectEOM(t,x,rho,Cd,A,m,g,wind_vel)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

gvect = [0;0;1];
fg = m.*g*gvect;

VE = [(x(4)-wind_vel(1));(x(5)-wind_vel(2));(x(6)-wind_vel(3))];

Va = norm(VE);

D = 0.5.*rho.*(Va.^2).*A.*Cd;

fd = -D.*(VE./Va);

a = (fd + fg)./m;

xdot = [x(4);x(5);x(6);a(1);a(2);a(3)];

end

