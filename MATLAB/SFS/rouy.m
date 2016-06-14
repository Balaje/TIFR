%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Program to implement the orthographic SfS model            
%       proposed by Rouy and Tourin.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear 
close all

format long

Nx = 100;
Ny = 100;

a = 0; b = 1;
c = 0; d = 1;

hx = (b-a)/Nx;
hy = (b-a)/Ny;

x = a:hx:b;
y = c:hx:d;

% Defining the index set
Q = zeros(Nx+1,Ny+1);
u = zeros(Nx+1,Ny+1);
unew = zeros(Nx+1,Ny+1);


for i=1:Nx+1
    for j=1:Ny+1
        if(I(x(i),y(j)) ~= 1)
            Q(i,j) = 1;
            if(x(i) == 0.5 && y(j) == 0.5)
                u(i,j) = 2;
            else
                u(i,j) = 1;
            end
        else
            Q(i,j) = 0;
        end
    end
end

delt = hx*hy/sqrt(hx^2+hy^2);

error = 100;
tol = 1e-5;

iterations = 0;
while error > tol

    for i = 2:Nx
        for j = 2:Ny
            if(Q(i,j) == 0)
                if(x(i) == 0.5 && y(j) == 0.5)
                    unew(i,j) = 2;
                else
                    unew(i,j) = 1;
                end
                
            else
                Dxp = (u(i,j)-u(i+1,j))/hx;
                Dxm = (u(i,j)-u(i-1,j))/hx;
                Dyp = (u(i,j)-u(i,j+1))/hy;
                Dym = (u(i,j)-u(i,j-1))/hy;
            
                Dx = max([0,Dxp,Dxm]);
                Dy = max([0,Dyp,Dym]);
            
                so = sqrt(1/(I(x(i),y(j)))^2 -1 );
                H = sqrt(Dx^2+Dy^2);
            
                unew(i,j) = u(i,j) - delt*(H-so);
            end 
        end
    end
    error = max(max(abs(unew-u)));
    u = unew;
    iterations = iterations + 1;
end

iterations
surf(x,y,unew)
