clc;
clear ;
%% load index

eps_xx = readmatrix("../examples/lumerical/index_x.txt").^2;
eps_yy = readmatrix("../examples/lumerical/index_y.txt").^2;
eps_zz = readmatrix("../examples/lumerical/index_y.txt").^2;


%% parameter

dx = 0.1e-6;
dy = 0.1e-6;
lambda = 1.55e-6;
k0 = 2 * pi / lambda;
% cx = 40;
% cy = 40;
% nx = cx + 1;
% ny = cy + 1;
[nx , ny] = size(eps_zz);
nt = nx * ny;

I = ones(nt, 1);
uxi = [-I, I];
% uxi(nx+1:nx:end, 2) = 0;
UX = spdiags(uxi/dx, [0, 1], nt, nt);

uyi = [-I, I];
UY = spdiags(uyi/dy, [0, nx], nt, nt);
% spy(DY)
VX = -UX';
VY = -UY';
%%

% eps_xx = interp1(1:nx, eps_xx , 1.5:nx+0.5  );
% eps_yy = interp1(1:ny , eps_yy' , 1.5:ny+0.5)';

erx = spdiags(eps_xx(:), 0, nt, nt);
ery = spdiags(eps_yy(:), 0, nt, nt);
erz = spdiags(eps_zz(:), 0, nt, nt);

I = spdiags(ones(nt, 1), 0, nt, nt);

Pxx = -k0^(-2) * UX * inv(erz) * VY * VX * UY + (k0^2 * I + UX * inv(erz) * VX) * (erx + k0^(-2) * VY * UY);
Pyy = -k0^(-2) * UY * inv(erz) * VX * VY * UX + (k0^2 * I + UY * inv(erz) * VY) * (ery + k0^(-2) * VX * UX);
Pxy = UX * inv(erz) * VY * (ery + k0^(-2) * VX * UX) - k0^(-2) * (k0^2 * I + UX * inv(erz) * VX) * VY * UX;
Pyx = UY * inv(erz) * VX * (erx + k0^(-2) * VY * UY) - k0^(-2) * (k0^2 * I + UY * inv(erz) * VY) * VX * UY;


P = [Pxx , Pxy ; Pyx , Pyy];

nmodes = 50;
[v,d] = eigs(P,nmodes,1.96*k0^2);
neff = sqrt(diag(d))/k0;


ex = reshape(v(1:nt,:),nx,ny , nmodes);

for i = 1:nmodes
pcolor(abs(ex(:,:,i))')
shading interp
colormap jet

drawnow
exportgraphics(gcf , num2str(i) + ".png")
end



%% 
F = mode_solve(dx,dy,nx,ny,1.4,nmodes,lambda,eps_xx(:) , eps_yy(:) , eps_zz(:) , zeros(nt,1) , zeros(nt,1), false);

for i = 1:nmodes
pcolor(abs(F.Ex(:,:,i))')
shading interp
colormap jet

drawnow
exportgraphics(gcf , num2str(i) + ".png")
end

F.neff - neff