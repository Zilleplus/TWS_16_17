% MANDELBROT_00 Non-optimised Mandelbrot function. On purpose, this code contains a bug and some superfluous code.
function R_tilde=mandelbrot_06(center,radius,steps,maxiter)

Z = zeros(steps,steps);
R_tilde =zeros(steps,steps);
C=zeros(steps,steps);

for n=1:steps
    for m=1:steps
        C(m+(n-1)*steps) = real(center)-radius+2*(n-1)*radius/(steps-1) ...
            + 1i*(imag(center)-radius+2*(m-1)*radius/(steps-1));
    end
end
R_tilde(1:steps,1:steps) = maxiter;
Z = C;
   
for r=1:maxiter
    [m,n] = find(R_tilde==maxiter);
    indices = m(1:end)+steps.*(n(1:end)-1);
    for j=1:length(n)
            Z(indices(j)) = Z(indices(j))*Z(indices(j)) + C(indices(j));
            if abs(Z(indices(j))) > 2
                    R_tilde(indices(j)) = r;
            end
    end
end