function [outwsn,G] = router_leach(wsn,rd,G)
%WSN_LEACH leach�ִ��㷨
%  ���� wsn�ṹ�� ��ǰ���� LEACH�Ѿ�ѡ�ٹ���ͷ����
%  ��� wsn�ṹ�� LEACH�Ѿ�ѡ�ٹ���ͷ����

% Ĭ�ϲ���
% ѭ������
round_per=10;

% ��ʼ��
num=wsn.num;
point=wsn.point;
pd=wsn.pdist;
outwsn=wsn;
p=1/round_per; % ������ռ�ڵ�ռ��
T_n=p/(1-p*(mod(rd-1,round_per)));
temp_aim=zeros(1,num);
% 
for i=find(G==0)'
    if(rand()<T_n)
        temp_aim(i)=1;
        G(i)=1;
    end  
end
% ���㵱�ִ�ͷ����������0��
temp_c=find(temp_aim(:).*point(:,5)==1);
% 
length_c=length(temp_c);

% ���û��ѡ����ͷ����Ӵ��ڵ��������ȡһ���ڵ�
if length_c~=0
%   ���ֻ��һ����ͷ
    if length_c==1
        point(:,4)=temp_c;
    else
    [~,temp_so]=min(pd(:,temp_c)');
    point(:,4)=temp_c(temp_so);
    end
%     ���û��ѡ�ٳ���ͷ,��ֱ�����վͨ��
else
    point(:,4)=1:num;
end
if mod(rd,round_per)==0
    G=zeros(wsn.num,1);
end
outwsn.point=point;

