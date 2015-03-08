clear all
clc
clf
 
x=1:0.2:(2*pi);
hold on
for i=1:9
    y=sin(x+i*pi/10)+exp(x/5);
    plot(x,y,'.-','Color',[(0.7+0.1/i)^2 1-(0.1*i) 0.5/i^2],'LineWidth',2+0.5*i);
    str{i}=['H=',mat2str(i*0.01)];
end
legend(str)
hold off