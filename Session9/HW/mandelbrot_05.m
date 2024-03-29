function R_tilde=mandelbrot_05(center,radius,steps,maxiter)

Z = zeros(steps,steps);
R_tilde =zeros(steps,steps);
C=zeros(steps,steps);
for n=1:steps
    for m=1:steps
        C(m,n) = real(center)-radius+2*(n-1)*radius/(steps-1) ...
            + 1i*(imag(center)-radius+2*(m-1)*radius/(steps-1));
    end
end
R_tilde(1:steps,1:steps) = maxiter;
Z = C;
   
for r=1:maxiter
    [m,n] = find(R_tilde==maxiter);
    for j=1:length(n)
        Z(m(j),n(j)) = Z(m(j),n(j))*Z(m(j),n(j)) + C(m(j),n(j));
        if abs(Z(m(j),n(j))) > 2
                R_tilde(m(j),n(j)) = r;
        end
    end
end