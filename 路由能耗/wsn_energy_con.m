function [ point_out ] = wsn_energy_con( wsn )
% energy_con һ�ֵ��ź��������

% ���������������㷨ģ�͡�
% �˺���δ���������ںϣ�����������ת��
% �˺���֧�ֶ��������ܺļ���

% point_all Ҫ����ĵ� ���а�����x,y,en,aim,flag��
% base ��վλ��,��һ������
% point_out ���Ĺ���ĵ�

% ȱʡ�ж�
if ~isfield(wsn,'flag_mix')
    wsn.flag_mix=false;
end
if ~isfield(wsn,'base_lo')
    wsn.base_lo=[wsn.r_all,wsn.r_all];
end

% --������ --
E_elec=50*10^-9;
asd_fs=10*10^-12;
asd_mp=1.3*10^-3*10^-12;
d_0=sqrt(asd_fs/asd_mp);%d_0��Ĭ��ֵ
k=4000;     %���δ���bit��

% --��ʼ������--
point=wsn.point;
base_lo=wsn.base_lo;
pd=wsn.pdist;
num=wsn.num;
point_out=wsn;
% --ͳ�ƾ���--
d2_c=zeros(num,1);
for i=1:num
d2_c(i)=pd(i,point(i,4));
end
% ��ͷ�ڵ㣨���վͨ�ţ�
temp_aim=find(point(:,4)'==1:num);
d2_c(temp_aim)=(point(temp_aim,1)-base_lo(1)).^2+(point(temp_aim,2)-base_lo(2)).^2;
% ͳ�ƴ��ײ㼶�����ȼ���㼶��͵�
lv_all=zeros(num,2);%�ֱ�ָ���ڵ�㼶���ڵ�����������ܺ�
temp_point=point(:,4)';

% --�жϲ㼶��ϵ
for j=1:num
    % ��ȷ����ͷ�ȼ�
    lv_all(temp_aim,1)=lv_all(temp_aim,1)+j;
    % �����µĴ��׽ڵ�
    temp_point(temp_aim)=0;
    temp_aim=find(ismember(temp_point,temp_aim));
    if isempty(temp_aim)
        break;
    end
    %
end
%  --�жϽ����˶�������
for i=j:-1:2
    for z=find(lv_all(:,1)==i)'
        lv_all(point(z,4),2)=lv_all(point(z,4),2)+lv_all(z,2)+1;
    end
end
for i=1:num
    % �жϽڵ��Ƿ��������������򲻼���
    if point(i,5)==1
        % �������ݺ���
        E_sum=lv_all(i,2)*k*E_elec;
        % �������ݺ���
        if d2_c(i)<d_0
            E_sum=k*E_elec+k*asd_fs*(d2_c(i))+E_sum;
        else
            E_sum=k*E_elec+k*asd_mp*(d2_c(i).^2)+E_sum;
        end
        % ��������
        point(i,3)=point(i,3)-E_sum;
        %  �жϽڵ��Ƿ�����
        if point(i,3)<0
            point(i,3)=0;
            point(i,5)=0;
        end
    end
end
point_out.point=point;