function [] = wsn_plot(wsn)
%WSN_PLOT 绘制WSN分簇情况
%   输入WSN结构体
point=wsn.point;
r=wsn.r_all;

live_point=find(point(:,5));
figure();
% 画出所有存活节点
plot(point(live_point,1),point(live_point,2),'.');hold on;
% 统计簇首节点
ch_point=live_point(point(live_point,4)'==live_point');
scatter(point(ch_point,1),point(ch_point,2),50,'filled');
% 画出存活节点指向簇首
line([point(live_point,1) point(point(live_point,4),1)]',[point(live_point,2) point(point(live_point,4),2)]');

% 限定坐标轴范围
axis equal
axis([0 2*r 0 2*r]);

end

