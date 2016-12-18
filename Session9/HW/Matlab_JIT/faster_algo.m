function [ a ] = faster_algo( a,n )   
    a = sqrt(2).*(sqrt(2).*(sqrt(1:n).*(sqrt(rand(1,n)).*a)));
end