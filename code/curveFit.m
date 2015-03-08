function [A,R]=curveFit(x,y,n)
% ����ʽ��Ϻ���
% ���룺x��y����ϴ���(��ֵ)n
% �����ϵ��A��ƽ��ֵR
A=polyfit(x,y,n);
% ����������ߵ� R ƽ��ֵ
fitValue=polyval(A,x);
rr=fitValue-y;% ���ֵ����ֵ�Ĳ�
total=y-mean(y);
total1=sum(total.*total);
rtotal=sum(rr.*rr);
R=(total1-rtotal)/total1;
end