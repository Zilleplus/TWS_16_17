% MANDELBROT_00 Non-optimised Mandelbrot function. On purpose, this code contains a bug and some superfluous code.
function R_tilde=mandelbrot_03(center,radius,steps,maxiter)

Z = zeros(steps,steps);
R_tilde =zeros(steps,steps);
C=zeros(steps,steps);

for m=1:steps
    for n=1:steps
        C(m,n) = real(center)-radius+2*(n-1)*radius/(steps-1) ...
            + 1i*(imag(center)-radius+2*(m-1)*radius/(steps-1));
        Z(m,n) = C(m,n);
        R_tilde(m,n) = maxiter;
        for r=1:maxiter
           if R_tilde(m,n) <= maxiter
                Z(m,n) = Z(m,n)*Z(m,n) + C(m,n);
                if abs(Z(m,n)) > 2
                    if(R_tilde(m,n)==maxiter)
                        R_tilde(m,n) = r;
                    end
                end
           end
        end
    end
end