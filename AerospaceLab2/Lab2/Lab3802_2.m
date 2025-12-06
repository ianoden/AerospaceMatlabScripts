%{
clc;
clear all;
close all;
%% Brass C360

t = linspace(1,1500000,100);

x = 4.875; %in
H = 8.7733; %C/in
L = 5.875; % ?
T0 = 4.93; %C
b_n = 8*H*L./(pi^2);

a1 = 3.593 * 10^-5;
a2 = 3.815 * 10^-5;
a3 = 3.851 * 10^-5;

u1 = T0 + H*x + b_n*sin(pi*x/(2*L))*exp(-((pi/(2*L))^2)*a1.*t);
u2 = T0 + H*x + b_n*sin(pi*x/(2*L))*exp(-((pi/(2*L))^2)*a2.*t);
u3 = T0 + H*x + b_n*sin(pi*x/(2*L))*exp(-((pi/(2*L))^2)*a3.*t);

hold on
plot(t,u1);
plot(t,u2);
plot(t,u3);
xlabel("Time(s)")
ylabel("Temperature at TH8(C)")
legend("a1 = 3.593 * 10^-5", "a2 = 3.815 * 10^-5", "a3 = 3.851 * 10^-5");
hold off

%}

clc;
close all;
clear;

H = 345.4061; %345.5446; %8.7733 c/in; 345.4061 c/m
alpha = 4.82E-5; %(m^2/s)
L = 0.14075; %(m)
x_TH8 = 0.11535; %(m)
T_0 = 4.93333; %4.33; %(deg. C) 4.93333 c

%% t = 1
t = 1;
Sum_terms = 0; 
n = 1:10;
Fo = alpha*t / L^2;

%% t = 1000
t2 = 1000;
Sum_terms2 = 0; 
n2 = 1:10;
Fo2 = alpha*t2 / L^2;

for i = 1:10
    b_n = ((8*H*L)./(((2*n(i) - 1)*pi).^2)).*(-1).^n(i);
    lambda_n = (((2.*n(i))-1).*pi)/(2.*L);
    Sum_terms(i+1) = Sum_terms(i) + (b_n .* sin(lambda_n .* x_TH8)) .* exp(-lambda_n.^2 .*alpha .* t);          
end

temperature = T_0 + H * x_TH8 + Sum_terms;



for i = 1:10
    b_n2 = ((8*H*L)./(((2*n2(i) - 1)*pi).^2)).*(-1).^n2(i);
    lambda_n2 = (((2.*n2(i))-1).*pi)/(2.*L);
    Sum_terms2(i+1) = Sum_terms2(i) + (b_n2 .* sin(lambda_n2 .* x_TH8)) .* exp(-lambda_n2.^2 .*alpha .* t2);          
end

temperature2 = T_0 + H * x_TH8 + Sum_terms2;
figure (1);
hold on;
plot(n,temperature(1:end-1));
plot(n2,temperature2(1:end-1));
title('Thermocouple 8 Temperature');
%set(gca, 'Fontsize' , 18);
xlabel('Summation Index Number');
ylabel('Temperature (C)');
hold off;




%%Question 6
t = linspace(0,2000,100);
a1 = 3.593 * 10^-5;
a2 = 3.815 * 10^-5;
a3 = 3.851 * 10^-5;

b_n = (8*H*L)./(((2*n(1)-1)*pi).^2).*(-1).^n(1);
lambda_n = (((2*n(1)) - 1).*pi)./(2*L);
u1 = T_0 + H.*x_TH8 + b_n.*sin(lambda_n.*x_TH8).*exp(-lambda_n.^2.*a1.*t);
u2 = T_0 + H.*x_TH8 + b_n.*sin(lambda_n.*x_TH8).*exp(-lambda_n.^2.*a2.*t);
u3 = T_0 + H.*x_TH8 + b_n.*sin(lambda_n.*x_TH8).*exp(-lambda_n.^2.*a3.*t);

figure(2);
hold on
plot(t,u1);
plot(t,u2);
plot(t,u3);
xlabel("Time(s)")
ylabel("Temperature at TH8 (C)")
title("Temperature vs Time at TH18")
legend("alpha 1 = 3.593*10^{-5} (m^2/s): matweb.com", "alpha 2 = 3.815: onlinemetals.com", "alpha 3 = 3.851: makeitfrom.com")
hold off




































