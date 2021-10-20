function [ out ] = wsn_point_create( wsn )
% 生成传感器节点
% 输出传感器节点 形式为（x,y,en,aim,flag）
% 即 x坐标 y坐标 节点能量 指向目标(如果指向自身则认为是汇聚节点？) 节点是否死亡标志位

% 输入wsn结构体 其中包含:
% 传感器数量 num
% 检测区域半径 r_all
% *传感器初始能量(默认0.5) base_en
% *生成形状(目前只支持 circle square) shape

% *表示可以缺省

%判断缺省值
if ~isfield(wsn,'base_en')
    wsn.base_en=0.5;
end
if ~isfield(wsn,'shape')
    wsn.shape='square';
end


% 初始化
R=wsn.r_all;
shape=wsn.shape;
num=wsn.num;
base_en=wsn.base_en;
x=zeros(1,num);y=zeros(1,num);
% 圆形时，生成的随机点，均匀分布
if strcmp(shape,'circle')
    for m=1:num
        rx=1;ry=1;
        while (rx*rx+ry*ry>1)
            rx=rand();
            ry=rand();
        end
        x(m)=R+((rand()>0.5)*-2*rx+rx)*R;
        y(m)=R+((rand()>0.5)*-2*ry+ry)*R;
    end
else
% 方形时，生成的随机点，均匀分布
    for m=1:num
        x(m)=rand()*2*wsn.r_all;
        y(m)=rand()*2*wsn.r_all;
    end
end

% 输出节点
out=[x;y;zeros(1,num)+base_en;zeros(1,num)+1;zeros(1,num)+1]';

end