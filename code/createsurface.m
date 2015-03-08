function [ M ] = createsurface( name,w,h,cellsize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% clc;
% cellsize=5;
x=1:1:w;
x=x.*cellsize;
y=1:1:h;
y=y.*cellsize;
try
    % Normal:random(name,mean,std,1,w)
    z = random(name,0,50,1,w);
    % Poisson
    z2 = random('Poisson',1:6,1,6);
    % Gamma
    z3=random('Gamma',10,5,1,w);
catch err
    % Sin
    xx=(x-1)./(w-1).*2*pi;
    z4=sin(xx);
end
M=[];
for i=1:h
    M=[M;z4];
end
figure,plot(x,M);
hold on;
figure,mesh(M);
% 生成w*h的随机分布矩阵
% hold on;
% for i = 1:h
%     eval(['r' num2str(i) '=rand(1,' num2str(w) ');']);
% end 
% x = [];
% for i = 1:h
%     x = eval(['[x; r' num2str(i) ']']);
% end
% figure,mesh(x);

% save as txt files in the format (*.ply2)
fid = fopen([name num2str(w) '_' num2str(h) '.ply2'], 'w');
[max_row, max_col] = size(M);
% row,col,cellsize
fprintf(fid,'%d,%d,%d\n',max_row,max_col,cellsize);
for row = 1:max_row
    for col = 1:max_col
        fprintf(fid,'%d,%d,%f\n',col*cellsize,(max_row-row+1)*cellsize,M(max_row-row+1, col));
    end
end
fclose(fid);
end

