function [] = wsn_plot(wsn)
%WSN_PLOT ����WSN�ִ����
%   ����WSN�ṹ��
point=wsn.point;
r=wsn.r_all;

live_point=find(point(:,5));
figure();
% �������д��ڵ�
plot(point(live_point,1),point(live_point,2),'.');hold on;
% ͳ�ƴ��׽ڵ�
ch_point=live_point(point(live_point,4)'==live_point');
scatter(point(ch_point,1),point(ch_point,2),50,'filled');
% �������ڵ�ָ�����
line([point(live_point,1) point(point(live_point,4),1)]',[point(live_point,2) point(point(live_point,4),2)]');

% �޶������᷶Χ
axis equal
axis([0 2*r 0 2*r]);

end

