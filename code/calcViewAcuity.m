function [p,d,A,R]=calcViewAcuity(width,near,far)
% 输入: width --长度
%       near --最近视点距离
%       far  --最远视点距离
% 输出: p --每个距离对应的像素数
%       d --距离值
%       A --拟合曲线参数，A(1)=a,A(2)=b
%       R --拟合曲线的平方值
% 
clc;
r=width/2;
p=zeros(1,far-near+1);
d=near:1:far;
for i=1:far-near+1
%   cos theta=(d*d-r*r)/(d*d+r*r)
%   alpha = theta*180/pi
%   p=alpha deg * 60 min/0.3 pi/min
%     p(i)=180*acos((d(i)*d(i)-r*r)/(d(i)*d(i)+r*r))*60/(pi*0.3);
    ratio(i)=1.0*d(i)/r;
    p(i)=180*acos(1-2/(4*ratio(i)*ratio(i)+1))*60/(pi*0.3);
end
pp=p/width;% 平均每单位长度对应的像素数
% if(mod(width,5)==0)
%     pause(0.5);
% end
set(0,'DefaultAxesFontName', 'Times New Roman')
% set(gcf,'Position',[100 100 260 220],'color','white');
% figure_FontSize=8;
% set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
% set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
% set(findobj('FontSize',10),'FontSize',figure_FontSize);

figure(1);plot(d,p,'-*');
xlabel('Depth (m)','fontsize',12,'fontweight','b');%
ylabel('Visual Information','fontsize',12,'fontweight','b');%
grid on;
mydir='';%uigetdir('','选择一个目录')
fig_path=[mydir 'tmp.tiff'];
% print(figure(1),'-dpng',fig_path);%'-dtiff','-cmyk','-r300',

% set(gcf,'color','white');
% F=getframe(gcf);
% imwrite(F.cdata,fig_path);
set(gcf,'color','white','paperpositionmode','auto');
saveas(gcf,fig_path);
disp([fig_path ' is saved......']);
% title('Visual Information - Depth','fontsize',12,'fontweight','b');
% title(['info:width=' num2str(width) 'distance=' num2str(near) '-' num2str(far)]);
% % figure,plot(near:1:far,ratio,'o');
% hold on;
% figure,plot(log(d),log(p),'*');%log=Ln()
% title(['log-log:width=' num2str(width) 'distance=' num2str(near) '-' num2str(far)]);
% title(['width:',num2str(width),' distance:',num2str(near),' to ',num2str(far)]);
% hold on;
% plot(d,pp,'*');

% dd=1./d;
% 在distance>width的区间内，对log(d)和log(p)进行线性拟合
logd=log(d);logp=log(p);
aa=d>width;
bb=find(aa,1,'first');
x=logd(bb:far-near+1);
y=logp(bb:far-near+1);
[A,R]=curveFit(x,y,1);
% [AA,RR]=curveFit(dd,pp,1);
% [AA,RR]=curveFit(log(d),log(p),2);%验证指数是否为2,结论为：大于一定d后，呈线性关系
% disp(A(1));
% disp(A(2));
% disp(RR);
% 输出像素数与距离值
name=['calc_l',num2str(width),'d',num2str(near),'_',num2str(far),'.txt'];
% disp(A(1));
% disp(A(2));
% save(name,'d','p','-ASCII');
result(1,:)=d;
result(2,:)=p;
result(3,:)=pp;
result=result';
% csvwrite(name,result);
end