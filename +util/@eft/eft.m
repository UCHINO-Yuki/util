classdef eft
    % EFT
    %
    %   Functions of error-free transformation
    %
    %   written ... 2024-08-03 ... UCHINO Yuki
    %

    properties (Constant)
        f_s = 4097;         % 1 + 2^12
        f_d = 134217729;    % 1 + 2^27
    end

    methods (Static, Access = private)
        function r = f(a)
            if nargin==0 || strcmp(a,'double')
                r = util.eft.f_d;
            else
                r = util.eft.f_s;
            end
        end
    end

    methods (Static)

        function [c,d] = FastTwoSum(a,b)
            %
            % T. J. Dekker,
            % ``A floating-point technique for extending the available precision,''
            % Numer. Math., vol. 18, no. 3, pp. 224--242, 1971.
            %
            c = a+b;
            d = (a-c) + b;
        end

        function [c,d] = TwoSum(a,b)
            %
            % D. E. Knuth,
            % ``Art of computer programming, volume 2: Seminumerical algorithms,''
            % Addison-Wesley Professional, 2014.
            %
            c = a+b;
            z = c-a;
            d = (a-(c-z))+(b-z);
        end

        function [ah,al] = Split(a)
            %
            % T. J. Dekker,
            % ``A floating-point technique for extending the available precision,''
            % Numer. Math., vol. 18, no. 3, pp. 224--242, 1971.
            %
            al = util.eft.f(underlyingType(a)).*a;
            ah = al-(al-a);
            al = a-ah;
        end

        function [c,d] = TwoProd(a,b)
            %
            % T. J. Dekker,
            % ``A floating-point technique for extending the available precision,''
            % Numer. Math., vol. 18, no. 3, pp. 224--242, 1971.
            %
            c = a .* b;
            [ah,al] = util.eft.Split(a);
            [bh,bl] = util.eft.Split(b);
            d = al.*bl - (((c - ah.*bh) - al.*bh) - ah.*bl);
        end

        function [c,d] = TwoProdFMA(a,b)
            c = a .* b;
            d = fma(a,b,-c);
        end

        function [x,y] = ExtractScalar(a,sigma)
            %
            % S. M. Rump, T. Ogita, and S. Oishi,
            % ``Accurate floating-point summation part I: Faithful rounding,''
            % SIAM J. Sci. Comput., vol. 31, no. 1, pp. 189--224, 2008.
            %
            x = (sigma + a) - sigma;
            y = a - x;
        end

        function [sum_p,p] = ExtractVector(p,sigma)
            %
            % S. M. Rump, T. Ogita, and S. Oishi,
            % ``Accurate floating-point summation part I: Faithful rounding,''
            % SIAM J. Sci. Comput., vol. 31, no. 1, pp. 189--224, 2008.
            %
            x = (sigma + p) - sigma;
            p = p - x;
            sum_p = sum(x);
        end
        
    end
end