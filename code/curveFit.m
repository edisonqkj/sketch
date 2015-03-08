function [A,R]=curveFit(x,y,n)
% 多项式拟合函数
% 输入：x、y、拟合次数(幂值)n
% 输出：系数A、平均值R
A=polyfit(x,y,n);
% 计算拟合曲线的 R 平方值
fitValue=polyval(A,x);
rr=fitValue-y;% 拟合值与真值的差
total=y-mean(y);
total1=sum(total.*total);
rtotal=sum(rr.*rr);
R=(total1-rtotal)/total1;
end