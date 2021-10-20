function [out] = cover(wsn)
% cover 布尔模型和指数模型
% 只支持点覆盖模型，方形区域

co_set=wsn.co_set;
x=wsn.co_x;
area=wsn.r_all*2;
point=wsn.point;

if strcmp(co_set,'index')
    % 指数感知模型参数
    r2=wsn.co_r2;
    r1=wsn.co_r1;
    L=wsn.co_L;
end
if strcmp(co_set,'bool')
    % 布尔模型参数
    r=wsn.co_r;
end

% 统计传感器存活节点
alive_point=point(point(:,5)>0,:);
% 初始化被感知节点坐标
point_aim = zeros(x+1,x+1,2);
point_aim(:,:,1) = ones(x+1,1)*linspace(0,area,x+1);
point_aim(:,:,2) = linspace(0,area,x+1)'*ones(1,x+1);
% 初始化
cover_point=zeros(x+1,x+1);
if strcmp(co_set,'index')
    % 指数感知覆盖主循环
    for i =1 : x+1
        for j = 1 : x+1
            %选出附近节点
            temp_point=alive_point((abs(alive_point(:,1)-point_aim(i,j,1))<r2),:);
            temp_point=temp_point(abs(temp_point(:,2)-point_aim(i,j,2))<r2,:);
            %初始化不被感知概率
            cover_temp=1;
            for k=1:length(temp_point(:,1))
                if (cover_temp==0)
                    break;
                end
                temp_len=(temp_point(k,1)-point_aim(i,j,1)).^2+(temp_point(k,2)-point_aim(i,j,2)).^2;
                %是否超出最大感知范围
                if temp_len<r2*r2
                    if temp_len>r1*r1
                        cover_temp = cover_temp*(1-exp(1)^((-L)*(sqrt(temp_len)-r1)));
                    else
                        cover_temp=0;
                    end
                end
            end
            cover_point(i,j)=1-cover_temp;
        end
    end
end

if strcmp(co_set,'bool')
    % 布尔感知覆盖主循环
    for i =1 : x+1
        for j = 1 : x+1
            %选出附近节点
            temp_point=alive_point((abs(alive_point(:,1)-point_aim(i,j,1))<r),:);
            temp_point=temp_point(abs(temp_point(:,2)-point_aim(i,j,2))<r,:);
            %初始化不被感知概率
            cover_temp=1;
            for k=1:length(temp_point(:,1))
                if (cover_temp==0)
                    break;
                end
                temp_len=(temp_point(k,1)-point_aim(i,j,1)).^2+(temp_point(k,2)-point_aim(i,j,2)).^2;
                if temp_len<r*r
                    cover_temp=0;
                end
            end
            cover_point(i,j)=1-cover_temp;
        end
    end
end

out=cover_point;

end

