% 三对角矩阵相乘
% A*x
% a b c 分别下 中 上
% 验证程序


function [y] = triMulti1(a, b, c, q, x)
% q 是对角位置

n = length(x);
y = zeros(size(x));


for i = 1:q
    y(i) = b(i) * x(i) + c(i) * x(i+q);
end

for i = q + 1:n - q
    y(i) = a(i) * x(i-q) + b(i) * x(i) + c(i) * x(i+q);
end

for i = n - q + 1:n
    y(i) = a(i) * x(i-q) + b(i) * x(i);
end
end

%% 测试

clear
a = [0; (1:100)'];
b = (1:101)';
c = [(1:100)'; 0];

t = triMulti1(a, b, c, 2, b)

full(spdiags([c, b, a], [-2, 0, 2], 101, 101).') * b
