function [DEM]=PointCloud3D(data,title1,interval,view_condition)
% clc;
% 1.������ά����
x=data(:,1);
y=data(:,2);
z=data(:,3);
figure,plot3(x,y,z,'r.');
% title(title1);
% % hold on;
grid on;
% hold off;
% 
%% 2.������ά����
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
Z=griddata(x,y,z,X,Y,'linear');%ZΪDEM
DEM=Z;

figure,surf(X,Y,Z);
title(['��λ��:' num2str(view_condition(1)) ' ���ǣ�' num2str(view_condition(2))]);
if (view_condition(1)<0)
    view_condition(1)=90+view_condition(1);
end
view(view_condition(1),view_condition(2));

% figure,mesh(X,Y,Z);
% title(title1);
% colorbar;
% hold on;
% 
% % ��sample 4 �е�DEM�ָ���ԭʼ״̬
% Z=Z';
% [row,col]=size(Z);
% for i=1:col
%     tmpZ(:,col-i+1)=Z(:,i);
% end
% Z=tmpZ;
% DEM=Z;
% data1=load('E:\�о�\vision\Data\generalData\after\1.1-3\pts_left.txt');
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
%% 3.���Ƶȸ���
figure
% intervalΪ�ȸ߾�
step=[minz:interval:maxz];%�ȸ߾�
[C,h]=contour(X,Y,Z,step,'COLOR',[0,0,0]);
% set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
% title([title1 ' generaliztion,Contour Interval:' num2str(interval)]);
% 

%% 4.����DEM
[row,col]=size(Z);
figure,imagesc([0,col],[row,0],Z);
% colorbar;
% title([title1 ' generaliztion,DEM']);
% 
%% 5.������ά��״ͼ
% figure,bar3(Z);
% figure,stem3(Z);
end