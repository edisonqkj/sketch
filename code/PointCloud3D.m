function [DEM]=PointCloud3D(data,title1,interval,view_condition)
% clc;
% 1.绘制三维点云
x=data(:,1);
y=data(:,2);
z=data(:,3);
figure,plot3(x,y,z,'r.');
% title(title1);
% % hold on;
grid on;
% hold off;
% 
%% 2.绘制三维曲面
minx=min(x);
maxx=max(x);
miny=min(y);
maxy=max(y);
minz=min(z);
maxz=max(z);
N=90;
[X,Y]=meshgrid(minx:N:maxx,miny:N:maxy);
% 'linear'    - Triangle-based linear interpolation (default)
% 'cubic'     - Triangle-based cubic interpolation
% 'nearest'   - Nearest neighbor interpolation
% 'v4'        - MATLAB 4 griddata method
Z=griddata(x,y,z,X,Y,'linear');%Z为DEM
DEM=Z;

figure,surf(X,Y,Z);
title(['方位角:' num2str(view_condition(1)) ' 仰角：' num2str(view_condition(2))]);
if (view_condition(1)<0)
    view_condition(1)=90+view_condition(1);
end
view(view_condition(1),view_condition(2));

% figure,mesh(X,Y,Z);
% title(title1);
% colorbar;
% hold on;
% 
% % 将sample 4 中的DEM恢复到原始状态
% Z=Z';
% [row,col]=size(Z);
% for i=1:col
%     tmpZ(:,col-i+1)=Z(:,i);
% end
% Z=tmpZ;
% DEM=Z;
% data1=load('E:\研究\vision\Data\generalData\after\1.1-3\pts_left.txt');
% x=data1(:,1);
% y=data1(:,2);
% z=data1(:,3);
% minx=min(x);
% maxx=max(x);
% miny=min(y);
% maxy=max(y);
% minz=min(z);
% maxz=max(z);
% N=90;
% [X,Y]=meshgrid(minx:N:maxx,miny:N:maxy);
% % 
%% 3.绘制等高线
figure
% interval为等高距
step=[minz:interval:maxz];%等高距
[C,h]=contour(X,Y,Z,step,'COLOR',[0,0,0]);
% set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
% title([title1 ' generaliztion,Contour Interval:' num2str(interval)]);
% 

%% 4.绘制DEM
[row,col]=size(Z);
figure,imagesc([0,col],[row,0],Z);
% colorbar;
% title([title1 ' generaliztion,DEM']);
% 
%% 5.绘制三维柱状图
% figure,bar3(Z);
% figure,stem3(Z);
end