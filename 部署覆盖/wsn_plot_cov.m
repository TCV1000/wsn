function [] = wsn_plot_cov(wsn)
%wsn_plot_cov 绘制覆盖热点图
%   此处显示详细说明
area=wsn.r_all*2;
x=wsn.co_x;
cov=cover(wsn);

lim = linspace(0,area,x+1);
[X,Y]=meshgrid(lim);
figure();
contourf(X,Y,cov) %等高线图
hold on
colorbar;

end

