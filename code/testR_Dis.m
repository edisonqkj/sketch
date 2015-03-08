function [R]=testR_Dis(l,min,max)
% 假设像素数与距离呈幂函数关系，检验拟合曲线的逼近程度
% 保持长度不变，逐渐增大测试的距离值；
% Results:随着距离值的增大，R先变小(distance<length)，(distance>length)后逐渐增大至稳定接近于1.
% 输入: l --长度变量
%       min --最小距离值
%       max --最大距离值
% 输出: R --拟合曲线的平方值
% 
clc;
tic;
R=zeros(1,max-min+1);
d=min:1:max;
for i=1:max-min+1
    [p,dd,A,r]=calcViewAcuity(l,1,d(i));
    R(i)=r;
end
figure,plot(d,R,'o');
title('R-Distance');
name=['R-D_',num2str(l),'_',num2str(min),'_',num2str(max),'.txt'];
csvwrite(name,R');
toc;
end