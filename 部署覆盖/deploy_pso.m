function [out_wsn] = deploy_pso(wsn)
%deploy_pso 对无线传感网络进行粒子群部署
% 调用了matlab自带的粒子群函数particleswarm
%  
num=wsn.num;
% 粒子上下限
lb=zeros(1,num*2);
ub=zeros(1,num*2)+wsn.r_all*2;
% 粒子群算法

fitness=@fitness_co;
% 粒子群参数设置，详见https://ww2.mathworks.cn/help/gads/particleswarm.html?searchHighlight=pso&s_tid=srchtitle
options = optimoptions('particleswarm','SwarmSize',20,'Display','iter','DisplayInterval',200);
x = particleswarm(fitness,num*2,lb,ub,options);

wsn.point(:,1:2)=reshape(x,[],2);
out_wsn=wsn;

% 适应度函数 输入坐标输出覆盖
function cov=fitness_co(encode)
temp_point=reshape(encode,[],2);
wsn.point(:,1)=temp_point(:,1);
wsn.point(:,2)=temp_point(:,2);
cov=-mean(mean(cover(wsn)));
end

end

