function xl = shift_left(x, n)

ng = length(x);
xl = [x(n+1:ng); x(ng-n+1:ng)];

% ng-(n+1) + 1 == ng-n
% ng - (ng-n+1) + 1 == n

end
