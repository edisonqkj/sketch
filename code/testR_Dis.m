function [R]=testR_Dis(l,min,max)
% �����������������ݺ�����ϵ������������ߵıƽ��̶�
% ���ֳ��Ȳ��䣬��������Եľ���ֵ��
% Results:���ž���ֵ������R�ȱ�С(distance<length)��(distance>length)�����������ȶ��ӽ���1.
% ����: l --���ȱ���
%       min --��С����ֵ
%       max --������ֵ
% ���: R --������ߵ�ƽ��ֵ
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