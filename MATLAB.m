% Numerical_Integration.m
% Date: 28.06.2019. Created by Joshua Simon.

clear
format compact
format long

% Create some functions you want to integrate like this:
g = @(x) x^2;
h = @(x) sin(x);

interval_a = 0;       % Lower interval bound 
interval_b = 4;       % Upper interval bound
n = 100;              % Number of subintervals

% Call functions to calculate integral value
% Example 1:
integral_g_1 = com_simpson(g, interval_a, interval_b, n);
integral_g_2 = trapez(g, interval_a, interval_b, n);

% Example 2:
integral_h_1 = com_simpson(h, 0.00, 3.141592654/2.0, 400);
integral_h_2 = trapez(h, 0.00, 3.141592654/2.0, 100);

% Output
disp(['Integral of g(x) over [', num2str(interval_a), ' , ', num2str(interval_b), ']'])
disp(['Simpson: ', num2str(integral_g_1)])
disp(['Trapez: ', num2str(integral_g_2)])
disp(['Exact value is ', num2str(1/3 * (4*4*4))])
fprintf('\n')

disp('Integral of g(x) over [0 , pi/2]')
disp(['Simpson: ', num2str(integral_h_1)])
disp(['Trapez: ', num2str(integral_h_2)])
disp(['Exact value is ', num2str(-cos(3.141592654/2.) + cos(0.))])


function [integralValue] = com_simpson(f, a, b, n)
% Composite Simpson's rule
% Integration of function f over interval [a,b] where n is
% the number of subintervals. Accuracy only depends on the 
% number of subintervals.

sum = 0;

if(a > b)
    disp("ERROR: Lower interval bound a has to be smaller than upper bound b.")
    integralValue = 0;
end

% Step length h
h = (b - a) / n;

% Calculate integral value with composite simpson's rule
    for k = 0:n

        x_k = a + k * h;
		x_k1 = a + (k+1) * h;
		
		simpson = h/6 * ( f(x_k) + 4* f((x_k + x_k1)/2) + f(x_k1) );
		
        sum = sum + simpson;
    end
    
integralValue = sum;
end

function [integralValue] = trapez(f, a, b, n)
% Trapezoidal rule
% Integration of function f over interval [a,b] where n is
% the number of subintervals. Accuracy only depends on the 
% number of subintervals. The trapezoidal rule converges 
% rapidly for periodic functions.

sum = 0;

if(a > b)
    disp("ERROR: Lower interval bound a has to be smaller than upper bound b.")
    integralValue = 0;
end

% Step length h
h = (b - a) / n;

% Calculate integral value with trapezoidal rule
    for k = 1:n-1
        sum = sum + f(a + k*h);
    end

    integralValue = h * (0.5 * f(a) + 0.5 * f(b) + sum);

end





