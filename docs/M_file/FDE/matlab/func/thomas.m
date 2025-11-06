function x = thomas1(a, b, c, d)

n = length(d);
% a , b , c , d 同列
g = zeros(size(d));
r = zeros(size(d)); % 存放中间d

g(1) = c(1) / b(1);
r(1) = d(1) / b(1);

%正向
for i = 2:length(d)
    g(i) = c(i) / (b(i) - a(i) * g(i-1));
    r(i) = (d(i) - a(i) * r(i-1)) / (b(i) - a(i) * g(i-1));
end

%反向
x = zeros(size(d));
x(n) = r(n);
% x(n) = d(n)
for i = n - 1:-1:1
    x(i) = r(i) - g(i) * x(i+1);
end

end
%%
clear
a = [0; (1:100)'];
b = (1:101)';
c = [(1:100)'; 0];

t = thomas1(a, b, c, b)

full(spdiags([c, b, a], [-1, 0, 1], 101, 101).') \ b
