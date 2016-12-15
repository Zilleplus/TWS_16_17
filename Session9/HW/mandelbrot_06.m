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

% for n=1:steps
%     for m=1:steps
%         C(m,n) = real(center)-radius+2*(n-1)*radius/(steps-1) ...
%             + 1i*(imag(center)-radius+2*(m-1)*radius/(steps-1));     
for r=1:maxiter
    [m,n] = find(R_tilde==maxiter);
    for j=1:length(n)
       if R_tilde(m(j)+(n(j)-1)*steps) <= maxiter
            Z(m(j)+(n(j)-1)*steps) = Z(m(j)+(n(j)-1)*steps)*Z(m(j)+(n(j)-1)*steps) + C(m(j)+(n(j)-1)*steps);
            if abs(Z(m(j)+(n(j)-1)*steps)) > 2
                if(R_tilde(m(j)+(n(j)-1)*steps)==maxiter)
                    R_tilde(m(j)+(n(j)-1)*steps) = r;
                end
            end
       end
    end
end
%     end
% end