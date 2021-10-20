function [ point_out ] = wsn_energy_con( wsn )
% energy_con 一轮的信号能量损耗

% 常见的能量消耗算法模型。
% 此函数未考虑数据融合，仅考虑数据转发
% 此函数支持多跳网络能耗计算

% point_all 要计算的点 其中包含（x,y,en,aim,flag）
% base 基站位置,是一个坐标
% point_out 消耗过后的点

% 缺省判断
if ~isfield(wsn,'flag_mix')
    wsn.flag_mix=false;
end
if ~isfield(wsn,'base_lo')
    wsn.base_lo=[wsn.r_all,wsn.r_all];
end

% --参数表 --
E_elec=50*10^-9;
asd_fs=10*10^-12;
asd_mp=1.3*10^-3*10^-12;
d_0=sqrt(asd_fs/asd_mp);%d_0的默认值
k=4000;     %单次传输bit数

% --初始化数据--
point=wsn.point;
base_lo=wsn.base_lo;
pd=wsn.pdist;
num=wsn.num;
point_out=wsn;
% --统计距离--
d2_c=zeros(num,1);
for i=1:num
d2_c(i)=pd(i,point(i,4));
end
% 簇头节点（向基站通信）
temp_aim=find(point(:,4)'==1:num);
d2_c(temp_aim)=(point(temp_aim,1)-base_lo(1)).^2+(point(temp_aim,2)-base_lo(2)).^2;
% 统计簇首层级，优先计算层级最低的
lv_all=zeros(num,2);%分别指代节点层级，节点接收数据量总和
temp_point=point(:,4)';

% --判断层级关系
for j=1:num
    % 从确定簇头等级
    lv_all(temp_aim,1)=lv_all(temp_aim,1)+j;
    % 计算新的簇首节点
    temp_point(temp_aim)=0;
    temp_aim=find(ismember(temp_point,temp_aim));
    if isempty(temp_aim)
        break;
    end
    %
end
%  --判断接收了多少数据
for i=j:-1:2
    for z=find(lv_all(:,1)==i)'
        lv_all(point(z,4),2)=lv_all(point(z,4),2)+lv_all(z,2)+1;
    end
end
for i=1:num
    % 判断节点是否死亡，若死亡则不计算
    if point(i,5)==1
        % 接收数据耗能
        E_sum=lv_all(i,2)*k*E_elec;
        % 发送数据耗能
        if d2_c(i)<d_0
            E_sum=k*E_elec+k*asd_fs*(d2_c(i))+E_sum;
        else
            E_sum=k*E_elec+k*asd_mp*(d2_c(i).^2)+E_sum;
        end
        % 消耗能量
        point(i,3)=point(i,3)-E_sum;
        %  判断节点是否死亡
        if point(i,3)<0
            point(i,3)=0;
            point(i,5)=0;
        end
    end
end
point_out.point=point;