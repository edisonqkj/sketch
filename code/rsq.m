function [rrr,p]=rsq(x,y)
%%rrr ����õ���Rƽ��
%%p   ��ϵõ���ϵ��
a(1,:)=x;
a(2,:)=y;
p=polyfit(a(1,:),a(2,:),1);
b=polyval(p,a(1,:));
r=b-a(2,:);
total=a(2,:)-mean(a(2,:));
total1=sum(total.*total);
rtotal=sum(r.*r);
rrr=(total1-rtotal)/total1;
end