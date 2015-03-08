function [Y,A,R]=powerfit(x,y)
% 输入: x --拟合自变量
%       y --拟合因变量
% 输出: Y --拟合值
%       A --拟合曲线参数，A(1)=a,A(2)=b
%       R --拟合曲线的平方值
% 
clc;
% y=k/x^a+b;
% log(y)=k*log(x)+c
log_y=log(y);
log_x=log(x);
[A,R]=curveFit(log_x,log_y,1);
Y=exp(polyval(A,log_x));

% figure,plot(x,y,'o');
% hold on;
% plot(x,Y,'-');
% 输出像素数与距离值
% disp(A(1));
% disp(A(2));
end