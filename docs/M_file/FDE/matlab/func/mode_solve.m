function Field = mode_solve(varargin)

%% 物理常数

EPS0 = 8.8541878128e-12;
MU0 = pi * 4e-7;
C0 = 299792458;
Z0 = 376.73;

%% 全局参数

dx_ = varargin{1};
dy_ = varargin{2};
nx_ = varargin{3};
ny_ = varargin{4};
search_index = varargin{5};
nmodes = varargin{6};
lambda = varargin{7};
EPS_X = varargin{8};
EPS_Y = varargin{9};
EPS_Z = varargin{10};
EPS_XY = varargin{11};
EPS_YX = varargin{12};
ispml = varargin{13};
%% 导入折射率
% 大写矩阵，小写向量
% EPS_X = importdata("../examples/Rsoft/bptmp.ipf", " ", 4).data;
% EPS_Y = importdata("../examples/Rsoft/bptmp.ipf", " ", 4).data;
% EPS_Z = importdata("../examples/Rsoft/bptmp.ipf", " ", 4).data;
% EPS_XY = zeros(nx_, ny_);
% EPS_YX = zeros(nx_, ny_);

eps_xx = EPS_X;
eps_yy = EPS_Y;
eps_zz = EPS_Z;
eps_xy = EPS_XY;
eps_yx = EPS_YX;


x_ = (0:nx_ - 1)' * dx_;
y_ = (0:ny_ - 1)' * dy_;

%% 吸收边界

SX = ones(nx_, ny_);
SY = ones(nx_, ny_);
w0 = 2 * pi * C0 / lambda;
if ispml

    xlayer = 10;
    ylayer = 10;
    m = 3;
    R0 = 1e-8;
    alpha_max = 0.05;
    kappa_max = 13;

    % Z0 = sqrt(MU0/EPS0);
    sigma_x_max = -(m + 1) * log(R0) / 2 / Z0 / xlayer / dx_;
    sigma_y_max = -(m + 1) * log(R0) / 2 / Z0 / ylayer / dy_;


    eps0 = EPS0;

    for di = 1:xlayer
        p = (di / xlayer);
        kappa = 1 + (kappa_max - 1) * p^m;
        sigma = sigma_x_max * p^m;
        alpha = alpha_max * p;
        SX(xlayer-di+1, :) = kappa + sigma / (alpha + 1j * w0 * eps0);
        SX(nx_-xlayer+di, :) = kappa + sigma / (alpha + 1j * w0 * eps0);
    end

    for di = 1:ylayer
        p = (di / ylayer);
        kappa = 1 + (kappa_max - 1) * p^m;
        sigma = sigma_y_max * p^m;
        alpha = alpha_max * p;
        SY(:, ylayer-di+1) = kappa + sigma / (alpha + 1j * w0 * eps0);
        SY(:, ny_-ylayer+di) = kappa + sigma / (alpha + 1j * w0 * eps0);
    end

end


sx = reshape(SX, [], 1);
sy = reshape(SY, [], 1);
isx = 1 ./ sx;
isy = 1 ./ sy;

%% 构造矩阵

k0_ = 2 * pi / lambda;
nt_ = nx_ * ny_;
I = ones(nt_, 1);

Pxx_ = dxdxfuncVec(isx, sx.*eps_zz, eps_xx, nx_, ny_, dx_, dy_) ...
    +dydyfuncVec(isy, sy, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_xx, 0, nt_, nt_) ...
    +dxdyfuncVec(isx, sy.*eps_zz, eps_yx, nx_, ny_, dx_, dy_);

Pxy_ = dxdyfuncVec(isx, sy.*eps_zz, eps_yy, nx_, ny_, dx_, dy_) ...
    -dxdyfuncVec(isx, sy, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_xy, 0, nt_, nt_) ...
    +dxdxfuncVec(isx, sx.*eps_zz, eps_xy, nx_, ny_, dx_, dy_);

Pyx_ = dydxfuncVec(isy, sx.*eps_zz, eps_xx, nx_, ny_, dx_, dy_) ...
    -dydxfuncVec(isy, sx, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_yx, 0, nt_, nt_) ...
    +dydyfuncVec(isy, sy.*eps_zz, eps_yx, nx_, ny_, dx_, dy_);

Pyy_ = dydyfuncVec(isy, sy.*eps_zz, eps_yy, nx_, ny_, dx_, dy_) ...
    +dxdxfuncVec(isx, sx, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_yy, 0, nt_, nt_) ...
    +dydxfuncVec(isy, sx.*eps_zz, eps_xy, nx_, ny_, dx_, dy_);


P = [Pxx_, Pxy_; Pyx_, Pyy_];
					% suppress output
[e, v] = eigs(P,nmodes, search_index*search_index*k0_*k0_ );

neff = sqrt(diag(v)) / k0_;

% if ispml
% 
%     [~, idx] = sort(abs(imag(neff)),"ascend");
%     neff = neff(idx);
%     e = e(:, idx);
% 
% end

%% 计算电场
EX = reshape(e(1:nt_, :), nx_, ny_, []);
EY = reshape(e(nt_+1:end, :), nx_, ny_, []);

Ix = [-I, I];
Ix(1:nx_:nt_, 1) = 0;
Ix(nx_:nx_:nt_, 2) = 0;
DX = spdiags(Ix/2/dx_, [1, -1], nt_, nt_)';
% spy(DX)

Iy = [-I, I];
DY = spdiags(Iy/2/dy_, [nx_, -nx_], nt_, nt_)';
% spy(DY)


EZ = zeros(nx_, ny_, nmodes);
HX = zeros(nx_, ny_, nmodes);
HY = zeros(nx_, ny_, nmodes);
HZ = zeros(nx_, ny_, nmodes);

for midx = 1:nmodes

    beta = k0_ * neff(midx);

    ex = reshape(EX(:, :, midx), [], 1);
    ey = reshape(EY(:, :, midx), [], 1);

    et = [ex; ey];
    [~, idx] = max(abs(et));
    ex = ex / et(idx);
    ey = ey / et(idx);

    ez = 1 ./ (1j * beta) ./ eps_zz .* ( ...
        DX * (eps_xx .* ex + eps_xy .* ey) ...
        +DY * (eps_yx .* ex + eps_yy .* ey) ...
        );

    hx = 1 / (1j * w0 * MU0) .* (DY * ez + 1j * beta * ey);
    hy = 1 / (1j * w0 * MU0) .* (-1j * beta * ex - DX * ez);
    hz = 1 / (1j * w0 * MU0) .* (DX * ey - DY * ex);

    EX(:, :, midx) = reshape(ex, nx_, ny_);
    EY(:, :, midx) = reshape(ey, nx_, ny_);
    EZ(:, :, midx) = reshape(ez, nx_, ny_);
    HX(:, :, midx) = reshape(hx, nx_, ny_);
    HY(:, :, midx) = reshape(hy, nx_, ny_);
    HZ(:, :, midx) = reshape(hz, nx_, ny_);
end


Field.Ex = EX;
Field.Ey = EY;
Field.Ez = EZ;
Field.Hx = HX;
Field.Hy = HY;
Field.Hz = HZ;
Field.x = x_;
Field.y = y_;
Field.neff = neff;


end
