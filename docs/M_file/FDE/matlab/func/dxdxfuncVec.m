% p q r 系数
% function [s]=dxdxfuncVec(p,q,r,nx,ny,dx,dy)
%
% p =1./p;
%
% ng = nx * ny;
% a =  p.*[r(1);r(1:ng-1)]./([q(1);q(1:ng-1)]+q);
% b = - p.*r.*( 1./([q(1);q(1:ng-1)]+q) + 1./(q + [q(2:ng);q(ng)]) ) ;
% c =  p.*[r(2:ng);r(ng)]./( q + [q(2:ng);q(ng)]) ;
%
% a(1:nx:ng)=0;
% c(nx:nx:ng)=0;
%
% s = transpose( spdiags([c b a]*2/dx/dx , [-1 0 1] , ng ,ng ) );
%
% end

%%
function [s] = dxdxfuncVec(p, q, r, nx, ny, dx, dy)

ng = nx * ny;
q1 = shift_x(q, -1);
r1 = shift_x(r, -1);

q2 = q;
p2 = p;
r2 = r;

q3 = shift_x(q, 1);
r3 = shift_x(r, 1);


a = 2 / dx / dx ./ (q1 + q2) .* p2 .* r1;
b = -2 / dx / dx .* (1 ./ (q1 + q2) + 1 ./ (q2 + q3)) .* p2 .* r2;
c = 2 / dx / dx ./ (q2 + q3) .* p2 .* r3;

a(1:nx:ng) = 0;
c(nx:nx:ng) = 0;

s = transpose(spdiags([c, b, a], [-1, 0, 1], ng, ng));

end
