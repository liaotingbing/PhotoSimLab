% function [s] = dydxfuncVec(p,q,r,nx,ny,dx,dy)
%
% p =1./p;
% ng = nx * ny ;
%
% a =   p.*[zeros(nx+1,1);r(1:ng-(nx+1))].*[zeros(nx,1);1./q(1:ng-nx)];
% b = - p.*[zeros(nx-1,1);r(1:ng-(nx-1))].*[zeros(nx,1);1./q(1:ng-nx)];
% c = - p.*[r(nx:ng);zeros(nx-1,1)].*[1./q(nx+1:ng);zeros(nx,1)];
% d =   p.*[r(nx+2:ng);zeros(nx+1,1)].*[1./q(nx+1:ng);zeros(nx,1)];
%
% a(1:nx:ng)=0;
% b(nx:nx:ng)=0;
% c(1:nx:ng)=0;
% d(nx:nx:ng)=0;
%
% s = transpose( spdiags( [d c b a]/4/dx/dy ,...
%     [-nx-1 , -nx+1 , nx-1 , nx+1] , ng,ng) );
%
% end
%%
function [s] = dydxfuncVec(p, q, r, nx, ny, dx, dy)


ng = nx * ny;

q7 = shift_x(q, -nx);
q3 = shift_x(q, nx);
p0 = p;
r6 = shift_x(r, -(nx + 1));
r8 = shift_x(r, -(nx - 1));
r4 = shift_x(r, nx-1);
r2 = shift_x(r, nx+1);


a = 1 / 4 / dx / dy ./ q7 .* p0 .* r6;
b = -1 / 4 / dx / dy ./ q7 .* p0 .* r8;
c = -1 / 4 / dx / dy ./ q3 .* p0 .* r4;
d = 1 / 4 / dx / dy ./ q3 .* p0 .* r2;

a(1:nx:ng) = 0;
b(nx:nx:ng) = 0;
c(1:nx:ng) = 0;
d(nx:nx:ng) = 0;

s = transpose(spdiags([d, c, b, a], ...
    [-nx - 1, -nx + 1, nx - 1, nx + 1], ng, ng));

end
