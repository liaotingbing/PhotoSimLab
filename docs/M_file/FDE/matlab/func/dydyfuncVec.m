% function [s]=dydyfuncVec(p,q,r,nx,ny,dx,dy)
%
% p =1./p;
% ng = nx * ny;
% % z  = zeros(nx,1);
% a =  p.*[r(1:nx);r(1:ng-nx)]./([q(1:nx);q(1:ng-nx)] + q);
% b = - p.*r.*( 1./([q(1:nx);q(1:ng-nx)] + q) + 1./(q +[q(nx+1:ng);q(ng-nx+1:ng)]) );
% c =  p.*[r(nx+1:ng);r(ng-nx+1:ng)]./(q +[q(nx+1:ng);q(ng-nx+1:ng)]);
%
% s =  transpose( spdiags([c,b,a]*2/dy/dy,[-nx 0 nx],ng,ng));
% end
%%
% 函数测试
function [s] = dydyfuncVec(p, q, r, nx, ny, dx, dy)


ng = nx * ny;

q1 = shift_x(q, -nx);
r1 = shift_x(r, -nx);

q2 = q;
p2 = p;
r2 = r;

q3 = shift_x(q, nx);
r3 = shift_x(r, nx);

a = 2 / dy / dy ./ (q1 + q2) .* p2 .* r1;
b = -2 / dy / dy .* (1 ./ (q1 + q2) + 1 ./ (q2 + q3)) .* p2 .* r2;
c = 2 / dy / dy ./ (q2 + q3) .* p2 .* r3;

s = transpose(spdiags([c, b, a], [-nx, 0, nx], ng, ng));
end
