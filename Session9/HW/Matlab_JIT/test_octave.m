clc;clear all;close all;
n=10^7;
a=1:n;
r=rand;
numberOfTests = 100;

orginal=zeros(1,numberOfTests);
fast=zeros(1,numberOfTests);
feature('accel','off');
for i=1:numberOfTests
    tic;
    original_algo(a,n);
    orginal(i)=toc;
    tic;
    faster_algo( a,n );
    fast(i) = toc;
end
disp(['original:mean= ' num2str(mean(orginal)) ' variance=' num2str(var(orginal))  ]);
disp(['fast:mean= ' num2str(mean(fast)) ' variance=' num2str(var(fast))  ]);