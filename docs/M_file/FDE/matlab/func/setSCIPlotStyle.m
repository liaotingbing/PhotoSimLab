function setSCIPlotStyle()
% 恢复默认设置（避免多次叠加）
reset(0);

% 字体设置
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultAxesFontSize', 10);
set(0, 'DefaultTextFontSize', 10);

% 线条与标记
set(0, 'DefaultLineLineWidth', 2);
set(0, 'DefaultLineMarkerSize', 6);
% set(0, 'DefaultMarkerEdgbeColor', 'b'); % 标记点边缘颜色（黑色，更清晰）

% 坐标轴
% set(0, 'DefaultAxesLineWidth', 1.0);
% set(0, 'DefaultAxesTickLength', [0.02, 0.02]);
% set(0, 'DefaultAxesXMinorTick', 'on'); % 开启X轴小刻度（可选）
% set(0, 'DefaultAxesYMinorTick', 'on'); % 开启Y轴小刻度（可选）

% 图例
set(0, 'DefaultLegendFontSize', 12);
set(0, 'DefaultLegendLocation', 'best');
set(0, 'DefaultLegendBox', 'off');


end
