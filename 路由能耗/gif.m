% 读取数据
load data/leach

% 生成第1到20轮的GIF动画.间隔0.5s(只展示)
wsn_plot_an(ST_R(1:20),0.5)

% % 生成第GIF动画并保存
wsn_plot_an(ST_R,0.05,'s')