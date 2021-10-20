function [outwsn,G] = router_leach(wsn,rd,G)
%WSN_LEACH leach分簇算法
%  输入 wsn结构体 当前轮数 LEACH已经选举过簇头集合
%  输出 wsn结构体 LEACH已经选举过簇头集合

% 默认参数
% 循环轮数
round_per=10;

% 初始化
num=wsn.num;
point=wsn.point;
pd=wsn.pdist;
outwsn=wsn;
p=1/round_per; % 簇首所占节点占比
T_n=p/(1-p*(mod(rd-1,round_per)));
temp_aim=zeros(1,num);
% 
for i=find(G==0)'
    if(rand()<T_n)
        temp_aim(i)=1;
        G(i)=1;
    end  
end
% 计算当轮簇头（能量大于0）
temp_c=find(temp_aim(:).*point(:,5)==1);
% 
length_c=length(temp_c);

% 如果没有选出簇头，则从存活节点中随机抽取一个节点
if length_c~=0
%   如果只有一个簇头
    if length_c==1
        point(:,4)=temp_c;
    else
    [~,temp_so]=min(pd(:,temp_c)');
    point(:,4)=temp_c(temp_so);
    end
%     如果没有选举出簇头,则直接向基站通信
else
    point(:,4)=1:num;
end
if mod(rd,round_per)==0
    G=zeros(wsn.num,1);
end
outwsn.point=point;

