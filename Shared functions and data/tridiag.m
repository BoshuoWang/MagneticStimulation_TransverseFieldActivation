function Y = tridiag(A, B, C ,F)
%  Solve the  n x n  tridiagonal system for y:
% 
%  [ A(1)  C(1)                                  ] [  Y(1)  ]   [  F(1)  ]
%  [ B(2)  A(2)  C(2)                            ] [  Y(2)  ]   [  F(2)  ]
%  [       B(3)  A(3)  C(3)                      ] [        ]   [        ]
%  [            ...   ...   ...                  ] [  ...   ] = [  ...   ]
%  [                    ...    ...    ...        ] [        ]   [        ]
%  [                        B(n-1) A(n-1) C(n-1) ] [ Y(n-1) ]   [ F(n-1) ]
%  [                                 B(n)  A(n)  ] [  Y(n)  ]   [  F(n)  ]
% 
%  F must be a vector (row or column) of length n
%  A, B, C must be vectors of length n (note that B(1) and C(n) are not used)

% Y = zeros(n,1);   

n = length(F);
Y = zeros(n,1);
Cp = Y;
Cp(1) = C(1) / A(1);
Y(1)  = F(1) / A(1);

for ii = 2 : n
    W = A(ii) - B(ii) * Cp(ii-1) ;
    Cp(ii) = C(ii) / W;
    Y(ii)  = ( F(ii) - B(ii) * Y(ii-1) )  / W;
end

for ii = n-1 : -1 : 1
    Y(ii) = Y(ii) - Cp(ii) * Y(ii+1);
end

end