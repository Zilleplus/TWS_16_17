% MANDELBROT_99 Reference mandelbrot function.
function R_tilde=mandelbrot_99(center,radius,steps,maxiter)

R_tilde=zeros(steps);
for m=1:steps
    ci=imag(center)-radius+2*(m-1)*radius/(steps-1);
    for n=1:steps
        cr=real(center)-radius+2*(n-1)*radius/(steps-1);
        zr=cr;
        zi=ci;
        rmax=maxiter;
        for r=0:maxiter-1
            zrn=zr*zr-zi*zi+cr;
            zin=2*zi*zr+ci;
            zi=zin;
            zr=zrn;
            if (zr*zr+zi*zi)>4,
                rmax=r+1;
                break
            end
        end
        R_tilde(m,n)=rmax;
    end
end
