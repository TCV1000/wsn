function [] = wsn_plot_an(ST_R,pause_time,flag)
%WSN_PLOT_AN 绘制无线传感网络动画图

if nargin == 1
    % GIF间隔时间
    tim_a = 0.1;
else
    tim_a = pause_time;
end

flag_save = (nargin == 3);

% 绘图参数
pic_num=1;
for rd=1:length(ST_R)
    
    point=ST_R(rd).point;
    live_point=find(point(:,5));
    % 画出所有存活节点
    plot(point(live_point,1),point(live_point,2),'.');hold on;
    % 统计簇首节点
    ch_point=live_point(point(live_point,4)'==live_point');
    scatter(point(ch_point,1),point(ch_point,2),50,'filled');
    % 画出存活节点指向簇首
line([point(live_point,1) point(point(live_point,4),1)]',[point(live_point,2) point(point(live_point,4),2)]');
    title(strcat('第',num2str(rd),'轮'));
    axis equal
    axis([0 2*ST_R(1).r_all 0 2*ST_R(1).r_all]);
    
%   保存GIF图片
    if (flag_save)
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    if pic_num == 1
        imwrite(I,map,'data/test.gif','gif','Loopcount',inf,'DelayTime',tim_a);
    else
        imwrite(I,map,'data/test.gif','gif','WriteMode','append','DelayTime',tim_a);
    end
    pic_num = pic_num + 1;
    else
        pause(tim_a);
    end
    
    
    
    
    hold off
end

end

