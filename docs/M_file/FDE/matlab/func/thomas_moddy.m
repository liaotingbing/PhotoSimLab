function x = thomas1(a, b, c, p, d)

n = length(d);
% a , b , c , d 同列
g = zeros(size(d));
r = zeros(size(d)); % 存放中间d

g(1:p) = c(1:p) ./ b(1:p);
r(1:p) = d(1:p) ./ b(1:p);

%正向
for i = p + 1:n
    g(i) = c(i) / (b(i) - a(i) * g(i-p));
    r(i) = (d(i) - a(i) * r(i-p)) / (b(i) - a(i) * g(i-p));
end

%反向
x = zeros(size(d));
x(n:-1:n-p+1) = r(n:-1:n-p+1);
% x(n) = d(n)
for i = n - p:-1:1
    x(i) = r(i) - g(i) * x(i+p);
end

end
%%
clear
a = [0; (1:100)'];
b = (1:101)';
c = [(1:100)'; 0];

t = thomas1(a, b, c, 3, b)

full(spdiags([c, b, a], [-3, 0, 3], 101, 101).') \ b
