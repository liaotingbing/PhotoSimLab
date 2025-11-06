function xr = shift_right(x, n)

ng = length(x);

xr = [x(1:n); x(1:ng-n)];

% n
% ng-n

end
