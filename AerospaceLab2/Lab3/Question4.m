

taperRatio = linspace(0,1,100);  %ct/cr, cr = 1 ct = taper ratio
ARatio = [10,8,6,4];
b = zeros(4,100);
e = zeros(4,100);
c_L = zeros(4,100);
c_Di = zeros(4,100);
delta = zeros(4,100);
%initializing values and variables

for i = 1:100
    for j = 1:4    
        b(j,i) = ARatio(j)./(1-taperRatio(i));
    end
end %fill in a 4x100 matrix with all the wingspans corresponding
            % to every AR and taper ratio

i = 0;
j = 0;
for i = 1:100
    for j = 1:4
        [e(j,i),c_L(j,i),c_Di(j,i),delta(j,i)] = PLLT(b(j,i),0.118241,0.118246,taperRatio(i),1,0,-2.143328,0,1,50,4);
    end
end %run function to get e,cl,cdi, and delta for every AR and taper ratio


plot(taperRatio,delta(1,:));
hold on
plot(taperRatio,delta(2,:));
plot(taperRatio,delta(3,:));
plot(taperRatio,delta(4,:));
ylabel("Induced Drag Factor")
xlabel("Taper Ratio (ct/cr)")
legend("Aspect Ratio of 10", "AR of 8", "AR of 6", "AR of 4")
title("Induced Drag Factor vs. Taper Ratio")
hold off
%plotting result based on aspect ratio

%[e,c_L,c_Di,delta] = PLLT(33.333,0.118241,0.118246,3.70833,5.3333,0,-2.143328,0,1,50); %% testing


[e,c_L,c_Di,delta] = PLLT(33.333,0.118241,0.118246,0.01,1,0,-2.143328,0,1,50,4)
[e,c_L,c_Di,delta] = PLLT(33.333,0.118241,0.118246,0.2,1,0,-2.143328,0,1,50,4)
[e,c_L,c_Di,delta] = PLLT(33.333,0.118241,0.118246,0.5,1,0,-2.143328,0,1,50,4)


function [e,c_L,c_Di,delta] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N,alpha)

alpha = alpha *pi/180;  %angle of attack for true geometric angle of attack
geo_t = geo_t *(pi/180) + alpha;
geo_r = geo_r *(pi/180) + alpha;
aero_t = aero_t *(pi/180);
aero_r = aero_r *(pi/180);
%convert to radians

a0_t = a0_t *180/pi;
a0_r = a0_r *180/pi;
%convert to 1/radians

S = b.*(c_r+c_t)/2;
AR = b^2/S;
%wing surface area and aspect ratio - recalculate aspect ratio to keep
%function general

matb = zeros(N,1);
matA = zeros(N,N);
i = 1:N;
%preallocating matrixes A and b, as well as setting i as iterator

theta = (i*pi)/(2*N);
y = b*cos(theta)/2;
%convert iterations in i to iterations in theta, equate y back to theta

a0 = zeros(1,N);
c = zeros(1,N);
aero = zeros(1,N);
geo = zeros(1,N);
%preallocating for size


%for k = 1:N
%    a0(1,k) = (a0_t-a0_r)*cos(theta(k))+a0_r;
%    c(1,k) = (c_t - c_r)*cos(theta(k))+c_r;
%    aero(1,k) = (aero_t-aero_r)*cos(theta(k))+aero_r;
%    geo(1,k) = (geo_t - geo_r)*cos(theta(k))+geo_r;
%end
a0 = ((a0_t-a0_r)*2/b).*y + a0_r;
c = ((c_t - c_r)*2/b).*y + c_r;
aero = ((aero_t - aero_r)*2/b).*y + aero_r;
geo = ((geo_t - geo_r)*2/b).*y + geo_r;
%filling matricies linearly based on y = mx+b across wingspan

i = 0;
j = 0;
%reset iterators just in case

for i = 1:N
    matb(i) = geo(i) - aero(i);
    % fill in matrix b with geometric - zero lift angles of attack
    for j = 1:N
        matA(i,j) = (4*b)/(a0(i)*c(i)) * sin((2*j-1)*theta(i)) + (2*j-1)*sin((2*j-1)*theta(i))/sin(theta(i));
        % fill in A matrix with above formula 
    end
end

matX = matA\matb;
% solve for A's in matX, although they are iterated 1,2,3,4... they correspond to
% 1,3,5,7...


delta = 0;
%reset delta to 0 just in case
for d = 2:N
    delta = delta + (2*d-1).*((matX(d)./matX(1))).^2;
end
% setting delta equal to the sum of above formula


c_L = matX(1,1).*pi.*AR;
e = 1./(1+delta);
c_Di = c_L.^2/(pi.*e.*AR);
%using resulting A values and delta to find coefficients of lift and
%induced drag, as well as span efficiency factor


end