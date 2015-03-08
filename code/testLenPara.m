function [k,b,r,l]=testLenPara(min,max,near,far)
% �𽥸ı䱻�۲�����Ŀ��/����
% ��ÿ�����/���Ƚ��е�������
% ��ȡ���Ե�������߲���:k��b
% pixels=k*(1/distance)+b
% Results:
% ��max-min<<far-nearʱ��k-w����������ϵ;b-w������������ϵ;R-w���ݵݼ���ϵ;
% ��max-min>>far-nearʱ��k-w����������Ȼ��ݼ������ڹյ�;b-w����������ϵ;R-w���ݵݼ���ϵ;
% ����: min --������Сֵ
%       max --�������ֵ
%       near --�ӵ��������
%       far --�ӵ���Զ����
% ���: k(i) --��near-far�����£���i�������µ��������ϵ��a
%       b(i) --��near-far�����£���i�������µ�������߳�����b
%       r --��near-far�����£�ĳ�������µ��������ƽ��ֵR
%       l --����ֵ
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
% ����ÿ��������ߵ� kֵ&���� �Ĺ�ϵ
figure,subplot(3,1,1);
plot(l,k,'o');
title(['k from ' name]);
hold on;
% ����ÿ��������ߵ� bֵ&���� �Ĺ�ϵ
subplot(3,1,2);
plot(l,b,'*');
title(['b from ' name]);
% hold on;
% ����ÿ��������ߵ� Rֵ&���� �Ĺ�ϵ
subplot(3,1,3);
plot(l,r,'*');
title(['R*R from ' name]);
grid on;
% ������log-log���߻���ͬһ��figure��
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
%����b��Ln(l)�����Թ�ϵ,������
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
% �������:l,k,b,r
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