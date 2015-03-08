function vpts(sampleID,n)
% load all files of sample ID
% folder: 1.1-1 means "Method 1 is applied to sample 1 on the condition 1"
clc;
id=0;
for i=1:n
    for m=1:2
        id=id+1;
        path_eye=['E:\ÑÐ¾¿\vision\Data\generalData\after\'...
            num2str(sampleID) '.' num2str(m) '-' num2str(i) '\paras_eye.txt'];
        data=load(path_eye);
        data=data';
        eye(id,:)=data(1:3);
    end
end
eye
% draw eye locations
[r,c]=size(eye);
figure
hold on;
for i=1:r
    % normalize
    l=sqrt(eye(i,1)*eye(i,1)+eye(i,2)*eye(i,2));
    %
    plot(eye(i,1)/l,eye(i,2)/l,'r.');
    view(i,:)=0-eye(i,:)./l;
%     eye(i)/=l;
end
view
% hold off;
% figure
x=-1:0.01:1;
y1=sqrt(1-x.*x);
y2=-sqrt(1-x.*x);
plot(x,y1,'color',[0,0,0]);
plot(x,y2,'color',[0,0,0]);
plot(0,0,'.','color',[0,0,0]);
xaxis=[-3,0;3,0];
yaxis=[0,3;0,-3];
plot(xaxis,yaxis,'-','color',[0,0,0]);
% grid on;
hold off;
end

