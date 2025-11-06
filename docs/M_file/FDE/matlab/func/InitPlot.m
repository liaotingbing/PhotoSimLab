% Inilitialize plotting settings
% InitPlot(linewidth,fontsize,windowstyle,interpreter)
% InitPlot('remove') to restore factory settings

% XiaoCY 2022-02-22
%%
function InitPlot(varargin)

% reset(0);
% 1. 设置默认着色模式为 interp（插值平滑）
% 作用于所有 axes 对象（坐标系）中的表面/网格图
% 设置所有新创建的坐标系（Axes）默认着色模式为 interp
% set(groot, 'DefaultAxesShading', 'interp');

% 2. 设置默认颜色映射为 jet
% 作用于所有新创建的 figure（图形窗口）
% 将所有新图形的默认颜色映射设置为 jet
% set(groot, 'DefaultFigureColormap', jet);

% 3. 设置默认自动显示 colorbar
% 通过 figure 的 CreateFcn 回调，创建图形时自动添加 colorbar


p = inputParser;
p.addOptional('linewidth', 2);
p.addOptional('fontsize', 20);
p.addOptional('shading', 'interp');
p.addOptional('windowstyle', 'normal', @(s)ischar(s) || isstring(s));

if ispc % Windows
    interpreter = 'tex';
else
    interpreter = 'latex';
end
p.addOptional('interpreter', interpreter, @(s)ischar(s) || isstring(s));

if nargin == 1 && (ischar(varargin{1}) || isstring(varargin{1}))
    if strcmpi(varargin{1}, 'remove')
        useMyStyle = false;
        p.parse;
    end
else
    useMyStyle = true;
    p.parse(varargin{:});
end

linewidth = p.Results.linewidth;
fontsize = p.Results.fontsize;
windowstyle = p.Results.windowstyle;
interpreter = p.Results.interpreter;

colorVec = [; ...
    0.1765, 0.5216, 0.9412; ... % blue
    0.9569, 0.2627, 0.2353; ... % red
    0.0392, 0.6588, 0.3451; ... % green
    1.0000, 0.7373, 0.1961; ... % yellow
    0.9843, 0.4471, 0.6000; ... % pink
    0.4980, 0.4980, 0.4980; ... % gray
    0.7373, 0.7412, 0.1333; ... % olive
    0.0902, 0.7451, 0.8118; ... % cyan
    ];

% Run get(groot,'factory') to see what you can change.
% figure
myStyle = {; ...
    'defaultFigureColor', 'w'; ...
    'defaultAxesFontName', 'Serif'; ...
    'defaultAxesXGrid', 'on'; ...
    'defaultAxesYGrid', 'on'; ...
    'defaultAxesZGrid', 'on'; ...
    'defaultConstantLineAlpha', 1; ...
    'defaultAxesColorOrder', colorVec; ...
    'defaultFigureWindowStyle', windowstyle; ...
    'defaultAxesFontSize', fontsize; ...
    'defaultTextFontSize', fontsize; ...
    'defaultConstantLineFontSize', fontsize; ...
    'defaultLineLineWidth', linewidth; ...
    'defaultConstantLineLineWidth', linewidth; ...
    'defaultAnimatedlineLineWidth', linewidth; ...
    'defaultStairLineWidth', linewidth; ...
    'defaultStemLineWidth', linewidth; ...
    'defaultContourLineWidth', linewidth; ...
    'defaultFunctionlineLineWidth', linewidth; ...
    'defaultImplicitfunctionlineLineWidth', linewidth; ...
    'defaultErrorbarLineWidth', linewidth; ...
    'defaultScatterLineWidth', linewidth; ...
    'defaultAxesTickLabelInterpreter', interpreter; ...
    'defaultConstantlineInterpreter', interpreter; ...
    'defaultTextInterpreter', interpreter; ...
    'defaultLegendInterpreter', interpreter; ...
    'defaultColorbarTickLabelInterpreter', interpreter; ...
    'defaultGraphplotInterpreter', interpreter; ...
    'defaultPolaraxesTickLabelInterpreter', interpreter; ...
    'defaultTextarrowshapeInterpreter', interpreter; ...
    'defaultTextboxshapeInterpreter', interpreter; ...
    };

if useMyStyle
    for k = 1:size(myStyle, 1)
        set(groot, myStyle{k, 1}, myStyle{k, 2})
    end
else
    for k = 1:size(myStyle, 1)
        set(groot, myStyle{k, 1}, 'remove')
    end
end
end
