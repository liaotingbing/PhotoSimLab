function xs = shift_x(x, n)

% dis = abs(n) ;
ng = length(x);

if n < 0
    n = abs(n);
    xs = [x(1:n); x(1:ng-n)];
    % n
    % ng-n
else
    n = abs(n);
    xs = [x(n+1:ng); x(ng-n+1:ng)];
    % ng-(n+1) + 1 == ng-n
    % ng - (ng-n+1) + 1 == n
end


end
