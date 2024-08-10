classdef auxi
    % AUXI
    %
    %   Auxiliary functions
    %
    %   written ... 2024-08-03 ... UCHINO Yuki
    %

    methods (Static)

        function a = offdiag(a)
            [m,n] = size(a);
            a(1:m+1:m*n) = 0;
        end

        function s = randsvd(n,cnd,mode)
            arguments (Input)
                n       (1,1)   {mustBeInteger}                                     % size of A (n, [m n], or [m;n])
                cnd     (1,1)   {mustNotBeInRange(cnd,-1,1)}        = 1/sqrt(eps);  % the anticipate condition number.
                mode    (1,1)   {mustBeMember(mode,[-5:-1 1:5])}    = 3;            % distribution of s.
            end
            switch abs(mode)
                case 1
                    s = ones(n,1)/abs(cnd);
                    s(end) = 1;
                case 2
                    s = ones(n,1);
                    s(1) = 1/abs(cnd);
                case 3
                    s = logspace(0,-log10(abs(cnd)),n)';
                case 4
                    s = linspace(1,1/abs(cnd),n)';
                case 5
                    s = sort(cnd.^(-rand(n,1)),'descend');
            end
            if sign(cnd)*sign(mode)>0
                s = sort(s,'descend');
            else
                s = sort(s);
            end
        end

    end
end

function mustNotBeInRange(x,a,b)
% MUSTNOTBEINRANGERANGE
%
if a < x && x < b
    eid = 'Range:Invalid';
    msg = ['Value must be less than or equal to ' num2str(a) ', or greater than or equal to ' num2str(b) '.'];
    error(eid,msg)
end
end