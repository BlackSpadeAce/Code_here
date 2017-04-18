function  a_b_c = wblthree(x)
% f(x) = b*a^(-b)*(x-c)^(b-1)*exp(-((x-c)/a)^b)
% a ------  尺度参数
% b ------  形状参数
% c ------  位置参数

disp('样本区间及最大值与最小值之比:')
x_range = [min(x) max(x) max(x)/min(x)]
alpha = [0.05]; %置信水平

c = linspace(0,min(x)-0.01,1000000)';
min(x-min(x))
Len_c = length(c);
for i = 1 : Len_c
    [a_b(i,:),pci{i}] = wblfit(x-c(i),alpha);
    lnL(i,1) = - wbllike([a_b(i,:)],x-c(i));
    if a_b(i,2) <= 1
        break;
    end
end
c = c(1:i);
figure('name','wblthree--参数特征')
[max_lnL,position_max] = max(lnL);
subplot(311)
plot(c,lnL,'r',c(position_max),max_lnL,'rs')
title('c - lnL')
text(c(position_max),max_lnL,num2str(max_lnL));

subplot(312)
plot(c,a_b(:,1),'b',c(position_max),a_b(position_max,1),'bs')
text(c(position_max),median(a_b(:,1)),num2str(a_b(position_max,1)));
title('c - a')

subplot(313)
plot(c,a_b(:,2),'k',c(position_max),a_b(position_max,2),'ks')
text(c(position_max),median(a_b(:,2)),num2str(a_b(position_max,2)));
title('c - b')

lnL_a_b_c = sortrows([lnL a_b c],-1);
disp('遍历位置参数C时的极大似然法参数估计：')
a_b_c = lnL_a_b_c(1,2:end)
disp('样本X最大对数(ln(X))似然值：')
lnL = lnL_a_b_c(1)

a = a_b_c(1);
b = a_b_c(2);
c = a_b_c(3);
f = @(x,a,b,c) b*a^(-b)*(x-c).^(b-1).*exp(-((x-c)/a).^b);
t = linspace(c,max(x)*1.5,500);
y = f(t,a,b,c);
for i = 1 :length(y)
    F(i) = trapz(y(1:i));
end
y1 = zeros(size(x));
input = -10:0.01:10;
yn = cdf('Weibull',input, a,b,c);

figure('name','wblthree')
plot(t,y,'r',x,y1,'sr')
%plot(input,yn,'r')
%axis([0 max(t) 0 max(y)*1.1])

text(max(t)/4,max(y)/2,[ 'a = ' num2str(a,'%0.1f') ' ,b = ' ...
    num2str(b,'%0.3f') ' ,c=' num2str(c,'%0.0f')],'fontsize',12,'color','r')