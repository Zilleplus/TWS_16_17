% MANDELBROT_00 Non-optimised Mandelbrot function. On purpose, this code contains a bug and some superfluous code.
function R_tilde=mandelbrot_07(center,radius,steps,maxiter)

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
    Z(indices) = Z(indices).*Z(indices) + C(indices);
    if abs(Z(indices)) > 2
        if(R_tilde(indices)==maxiter)
            R_tilde(indices) = r;
        end
    end
end