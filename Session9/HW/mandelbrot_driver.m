% MANDELBROT_DRIVER Example of a call to the mandelbrot functions

clear variables; clc; close all;
set(0,'DefaultFigureWindowStyle','docked');

%% Parameters for an interesting part of the complex space
center  = -0.7465 + 0.1240i;
radius  = 0.0037;   
steps   = 256; % Change steps when the computation takes too much or too little time.
maxiter = 64;

% ranges
xr = real(center)+linspace(-radius,radius,steps);
yr = imag(center)+linspace(-radius,radius,steps);

%% Calculate for a range of revisions
revisions = [0:9, 99]; % Change this when you make a new revision.
R_tilde_ref = mandelbrot_99(center,radius,steps,maxiter);
for revisioni = 1:numel(revisions)
    % Select the revision and the corresponding function
    revision = revisions(revisioni);
    mandelbrot_fun = str2func(sprintf('mandelbrot_%02i',revision));
    fprintf('- Testing %s ... ',func2str(mandelbrot_fun));
    
    % Run the function
    R_tilde = mandelbrot_fun(center,radius,steps,maxiter);
    
    max_abs_err = max(abs((R_tilde(:)-R_tilde_ref(:))));
    fprintf(' max.abs.err.: %g\n', max_abs_err );
    
    % Create a figure with the result ...
    figure; clf;
    subplot(2,1,1);
    imagesc(xr,yr,R_tilde);
    axis image;
    colormap(jet);
    title(sprintf('Mandelbrot set (%ix%i, iters <=%i, rev. %02i)',...
        steps,steps,maxiter,revision));
    xlabel('Real(z)');
    ylabel('Imag(z)');
    set(gca,'XTick',[],'YTick',[]);
    disp(caxis);
    
    % ...  and the error
    subplot(2,1,2);
    imagesc(xr,yr,abs(R_tilde-R_tilde_ref) );
    axis image;
    colormap(jet);
    title(sprintf('Error plot (max.abs.err.: %g)', max_abs_err ));
    xlabel('Real(z)');
    ylabel('Imag(z)');
    set(gca,'XTick',[],'YTick',[]);
    colorbar('Location','East');
end
set(0, 'DefaultFigureVisible', 'on');

