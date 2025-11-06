addpath("func\")

%% 物理常数

EPS0 = 8.8541878128e-12;
MU0 = pi * 4e-7;
C0 = 299792458;
Z0 = 376.73;

%% 全局参数

dx_ = 0.1e-6/2;
dy_ = 0.1e-6/2;
nx_ = 81;
ny_ = 81;
search_index = 1.4;
nmodes = 60;
lambda = 1.55e-6;

%% 导入折射率
% 大写矩阵，小写向量
EPS_X = importdata("../examples/Rsoft/bptmp.ipf", " ", 4).data;
EPS_Y = importdata("../examples/Rsoft/bptmp.ipf", " ", 4).data;
EPS_Z = importdata("../examples/Rsoft/bptmp.ipf", " ", 4).data;
EPS_XY = zeros(nx_, ny_);
EPS_YX = zeros(nx_, ny_);

eps_x = EPS_X(:);
eps_y = EPS_Y(:);
eps_z = EPS_Z(:);
eps_xy = EPS_XY(:);
eps_yx = EPS_YX(:);


x_ = (0:nx_ - 1)' * dx_;
y_ = (0:ny_ - 1)' * dy_;

%% PML参数

w0 = 2 * pi * C0 / lambda;
pml = 10;
m = 3;
R0 = 1e-16; % 反射率
SigmaXMax = -(m + 1) * log(R0) / 2 / Z0 / (pml * dx_);
SigmaYMax = -(m + 1) * log(R0) / 2 / Z0 / (pml * dy_);

sx = ones(nx_, ny_);
% sx(1:11 , : ) = repmat(  1 + (( 10:-1:0)/10 ).' .^3 * SigmaXMax  / 1j / w0  /eps0  , 1 , ny_) ;
% sx(end:-1:end-10 , : ) = repmat(  1 + (( 10:-1:0)/10 ).' .^3 * SigmaXMax  / 1j / w0  /eps0  , 1 , ny_) ;

sy = ones(nx_, ny_);
% sy(: , 1:11 ) = repmat(  1 + (( 10:-1:0)/10 )  .^3 * SigmaXMax  / 1j / w0  /eps0  , nx_ , 1) ;
% sy(:  , end:-1:end-10 ) = repmat(  1 + (( 10:-1:0)/10 )  .^3 * SigmaXMax  / 1j / w0  /eps0  , nx_ , 1) ;
%
% sxvec =  sx(:);
% syvec =  sy(:);

sx = sx(:);
sy = sy(:);
isx = 1 ./ sx;
isy = 1 ./ sy;

%% 构造矩阵

k0_ = 2 * pi / lambda;
nt_ = nx_ * ny_;
I = ones(nt_, 1);

Pxx_ = dxdxfuncVec(isx, sx.*eps_z, eps_x, nx_, ny_, dx_, dy_) ...
    +dydyfuncVec(isy, sy, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_x, 0, nt_, nt_) ...
    +dxdyfuncVec(isx, sy.*eps_z, eps_yx, nx_, ny_, dx_, dy_);

Pxy_ = dxdyfuncVec(isx, sy.*eps_z, eps_y, nx_, ny_, dx_, dy_) ...
    -dxdyfuncVec(isx, sy, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_xy, 0, nt_, nt_) ...
    +dxdxfuncVec(isx, sx.*eps_z, eps_xy, nx_, ny_, dx_, dy_);

Pyx_ = dydxfuncVec(isy, sx.*eps_z, eps_x, nx_, ny_, dx_, dy_) ...
    -dydxfuncVec(isy, sx, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_yx, 0, nt_, nt_) ...
    +dydyfuncVec(isy, sy.*eps_z, eps_yx, nx_, ny_, dx_, dy_);

Pyy_ = dydyfuncVec(isy, sy.*eps_z, eps_y, nx_, ny_, dx_, dy_) ...
    +dxdxfuncVec(isx, sx, I, nx_, ny_, dx_, dy_) ...
    +spdiags(k0_*k0_*eps_y, 0, nt_, nt_) ...
    +dydxfuncVec(isy, sx.*eps_z, eps_xy, nx_, ny_, dx_, dy_);


P = [Pxx_, Pxy_; Pyx_, Pyy_];

[e, v] = eigs(P, nmodes, search_index*search_index*k0_*k0_ ,"Tolerance",1e-12    );

neff = sqrt(diag(v)) / k0_;

%% 计算电场
EX = reshape(e(1:nt_, :), nx_, ny_, []);
EY = reshape(e(nt_+1:end, :), nx_, ny_, []);

Ix = [I, -I];
Ix(1:nx_:nt_, 2) = 0;
Ix(nx_:nx_:nt_, 1) = 0;
DX = spdiags(Ix/2/dx_, [-1, 1], nt_, nt_)';
% spy(DX)

Iy = [I, -I];
DY = spdiags(Iy/2/dy_, [-nx_, nx_], nt_, nt_)';
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

    ez = 1 ./ (1j * beta) ./ eps_z .* ( ...
        DX * (eps_x .* ex + eps_xy .* ey) ...
        +DY * (eps_yx .* ex + eps_y .* ey) ...
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

Field = {EX, EY, EZ, HX, HY, HZ};
Component = {"Ex", "Ey", "Ez", "Hx", "Hy", "Hz"};


fid = fopen("_Field.md", "w");
%% 保存图像


for cs = 1:6

    path = "images/" + Component{cs} + "/";
    mkdir(path);

    for midx = 1:nmodes
        fprintf(Component{cs}+"写入模式%d\n", midx);
        f = Field{cs}(:, :, midx);
        pcolor(x_, y_, abs(f).');
        xlabel("X m")
        ylabel("Y m")

        title(Component{cs}+" Amp Mode "+num2str(midx)+" neff="+num2str(neff(midx)));
        colorbar;
        axis equal
        shading interp
        colormap jet


        filename = path + Component{cs} + "_Amp_Mode_" + num2str(midx) + ".png";
        saveas(gcf , filename)

        fprintf(fid, "![]("+filename+")\n");
    end

end

fclose(fid);
%% 结构绘图
pcolor(x_, y_, EPS_X');
title("Structure EPS X");
colorbar;
axis equal
xlabel("X m")
ylabel("Y m")
% shading interp
colormap jet
saveas(gcf , "Structure_EPS_X.png")

pcolor(x_, y_, EPS_Y');
title("Structure EPS Y");
xlabel("X m")
ylabel("Y m")
colorbar;
axis equal
% shading interp
colormap jet
saveas(gcf , "Structure_EPS_Y.png")

pcolor(x_, y_, EPS_Z');
title("Structure EPS Z");
xlabel("X m")
ylabel("Y m")
colorbar;
axis equal
% shading interp
colormap jet
saveas(gcf , "Structure_EPS_Z.png")
