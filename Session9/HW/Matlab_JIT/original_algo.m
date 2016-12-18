function [ a ] = original_algo( a,n )
    for i =1:n; a( i ) = sqrt (rand) * a( i ); end ;
    for i =1:n; a( i ) = sqrt ( i ) * a( i ); end ;
    for i =1:n; a( i ) = sqrt (2) * a( i ); end ; 
    sqrt2 = sqrt (2); 
    for i =1:n; a( i ) = sqrt2 * a( i ); end ;
end

