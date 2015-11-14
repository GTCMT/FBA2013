function out = princarg(X)

y = X + pi;
y = mod(y,2*pi);
out = y - pi;

end
