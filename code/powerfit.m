function [Y,A,R]=powerfit(x,y)
% ����: x --����Ա���
%       y --��������
% ���: Y --���ֵ
%       A --������߲�����A(1)=a,A(2)=b
%       R --������ߵ�ƽ��ֵ
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
% ��������������ֵ
% disp(A(1));
% disp(A(2));
end