function []=simulate_surface()
% load clown
% surface(peaks,flipud(X),...
%    'FaceColor','texturemap',...
%    'EdgeColor','none',...
%    'CDataMapping','direct')
% colormap(map)

[x,y] = meshgrid(-3:.06:3);
z = peaks(x,y);
z(z<1)=0;
% meshc(X,Y,Z);
surfl(x,y,z);
shading interp
colormap(gray);
% axis([-3 3 -3 3 -10 5])

view(-35,45)
disp(size(z))

fid = fopen('gauss.ply2', 'w');
cellsize=5
[max_row, max_col] = size(z);
min_z=min(z(z>1))
max_z=max(z(:))
% row,col,cellsize
% fprintf(fid,'%d,%d,%d\n',max_row,max_col,cellsize);
for row = 1:max_row
    for col = 1:max_col
        if z(max_row-row+1, col)>1
            fprintf(fid,'%d,%d,%f\r\n',col*cellsize,...
                (max_row-row+1)*cellsize,...
                (z(max_row-row+1, col)-min_z)*100/(max_z-min_z)+0);
        end
    end
end
fclose(fid);
end