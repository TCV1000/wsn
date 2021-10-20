% 无线传感网络能耗
% 建议将无限传感网络中，相关参数用结构体WSN储存起来，方便传参

% ----初始化变量
% clear all
% 检测区域半径
wsn.r_all=150;
% 检测区域形状
wsn.shape='circle';
% 传感器数量
wsn.num=180;
% 传感器初始能量；
wsn.base_en=0.5;
% 最大模拟轮数
wsn.max_round=1000;
% 基站坐标
wsn.base_lo=[0,0];

% 生成初始节点
wsn.point=wsn_point_create(wsn);

% 是否读取已生产数据
flag_load=false
if flag_load
    load data\base_data
else
    save data\base_data wsn
end

% 绘制生成的节点，可以注释掉
plot(wsn.point(:,1),wsn.point(:,2),'.');

% -----初始化统计变量
% 统计距离的平方函数，减少计算量
wsn.pdist=squareform(pdist(wsn.point(:,1:2),'squaredeuclidean'));
% 初始化Leach变量
G=zeros(wsn.num,1);
% --初始化各项统计数据--
% 统计每轮节点数据
ST_R=struct;
% 统计其他参数
ST_N.first_death=false;

% -----主循环
for round=1:wsn.max_round
    % 路由算法对节点分簇
    [wsn,G]=router_leach(wsn,round,G);
    
    % 绘制节点分簇图（每多少轮绘制一次图）
    if mod(round,100)==0
        wsn_plot(wsn);
    end
    
    % 根据分簇情况计算能量消耗
    wsn=wsn_energy_con(wsn);
 
    % --统计相关信息--
    % 统计节点每轮情况
    ST_R(round).point=wsn.point;
    ST_R(round).r_all=wsn.r_all;
    % 统计节点每轮剩余能量总和
    ST_R(round).en=sum(wsn.point(:,3));
    % 统计每轮存活点数
    ST_R(round).alive_num=sum(wsn.point(:,5));
    
    % 统计节点第一次死亡时轮数
    if ~ST_N.first_death
        if ~isempty(find(wsn.point(:,5)==0, 1))
            ST_N.first_death=round;
        end
    end
    
    % 中止判断
    if isempty(find(wsn.point(:,5), 1))
        break;
    end
    
end


% 绘制相关图形

% 能量随轮数分布图
figure()
plot(arrayfun(@(x) x.en,ST_R))

% 存活节点随轮数分布图
figure()
plot(arrayfun(@(x) x.alive_num,ST_R))

% 第一次出现死亡时节点分布图(或指定轮数)
figure()
if ST_N.first_death
    wsn_plot(ST_R(ST_N.first_death))
else
    disp('节点没有出现死亡')
end

% 第一次出现死亡时节点能量剩余分布图
figure()
if ST_N.first_death
    plot(ST_R(ST_N.first_death).point(:,3))
    ylim([0,wsn.base_en])
else
    disp('节点没有出现死亡')
end

%  存档
save data\leach ST_N ST_R