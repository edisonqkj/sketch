function [k,b,r,l]=testLenPara(min,max,near,far)
% 逐渐改变被观察物体的宽度/长度
% 对每个宽度/长度进行迭代测试
% 提取测试的拟合曲线参数:k、b
% pixels=k*(1/distance)+b
% Results:
% 当max-min<<far-near时，k-w呈幂增长关系;b-w呈线性增长关系;R-w呈幂递减关系;
% 当max-min>>far-near时，k-w先幂增长，然后递减，存在拐点;b-w呈幂增长关系;R-w呈幂递减关系;
% 输入: min --长度最小值
%       max --长度最大值
%       near --视点最近距离
%       far --视点最远距离
% 输出: k(i) --在near-far条件下，第i个长度下的拟合曲线系数a
%       b(i) --在near-far条件下，第i个长度下的拟合曲线常数项b
%       r --在near-far条件下，某个长度下的拟合曲线平方值R
%       l --长度值
clc;
tic;
l=min:1:max;
k=zeros(1,max-min+1);
b=zeros(1,max-min+1);
r=zeros(1,max-min+1);
% p=[];
% d=[];
for i=1:max-min+1
    [p1,d1,A,R]=calcViewAcuity(l(i),near,far);
    p(i,:)=p1;
    d(i,:)=d1;
    k(i)=A(1);
    b(i)=A(2);
    r(i)=R;
end
name=['width=' num2str(min) '-' num2str(max) ',distance=' num2str(near) '-' num2str(far)];
% 绘制每次拟合曲线的 k值&长度 的关系
figure,subplot(3,1,1);
plot(l,k,'o');
title(['k from ' name]);
hold on;
% 绘制每次拟合曲线的 b值&长度 的关系
subplot(3,1,2);
plot(l,b,'*');
title(['b from ' name]);
% hold on;
% 绘制每次拟合曲线的 R值&长度 的关系
subplot(3,1,3);
plot(l,r,'*');
title(['R*R from ' name]);
grid on;
% 将所有log-log曲线绘制同一个figure中
figure
title(name);
hold on;
for i=1:max-min+1
    if(mod(i,100)==0)
        plot(log(d(i,:)),log(p(i,:)),'.-','Color',[(i-1)/(max-min) 0 0]);
        str{i/100}=['H=',mat2str(l(i))];
    end
end
legend(str)
grid on;
hold off;
%检验b与Ln(l)的线性关系,成立！
[AA,RR]=curveFit(log(l),b,1);
str2{1}=['b-log(l)'];
str2{2}=['fit:',num2str(AA(1)),'*log(l)+',num2str(AA(2))];
figure,plot(log(l),b,'*','COLOR',[0,0,1]);
hold on;
plot(log(l),AA(1)*log(l)+AA(2),'-','COLOR',[1,0,0]);
legend(str2);
grid on;
hold off;
title('b-l');
% 输出数据:l,k,b,r
name=['testKBR_l',num2str(min),'_',num2str(max),'d',num2str(near),'_',num2str(far),'.txt'];
% disp(A(1));
% disp(A(2));
% save(name,'l','k','b','r','-ASCII');
result(1,:)=l;
result(2,:)=k;
result(3,:)=b;
result(4,:)=r;
result=result';
% csvwrite(name,result);
toc;
end