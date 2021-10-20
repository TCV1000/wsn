function [] = wsn_plot_an(ST_R,pause_time,flag)
%WSN_PLOT_AN �������ߴ������綯��ͼ

if nargin == 1
    % GIF���ʱ��
    tim_a = 0.1;
else
    tim_a = pause_time;
end

flag_save = (nargin == 3);

% ��ͼ����
pic_num=1;
for rd=1:length(ST_R)
    
    point=ST_R(rd).point;
    live_point=find(point(:,5));
    % �������д��ڵ�
    plot(point(live_point,1),point(live_point,2),'.');hold on;
    % ͳ�ƴ��׽ڵ�
    ch_point=live_point(point(live_point,4)'==live_point');
    scatter(point(ch_point,1),point(ch_point,2),50,'filled');
    % �������ڵ�ָ�����
line([point(live_point,1) point(point(live_point,4),1)]',[point(live_point,2) point(point(live_point,4),2)]');
    title(strcat('��',num2str(rd),'��'));
    axis equal
    axis([0 2*ST_R(1).r_all 0 2*ST_R(1).r_all]);
    
%   ����GIFͼƬ
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

