classdef cpair
    % CPAIR 
    %
    %   Fast pair arithmetic proposed in follows:
    %       M. Lange and S. M. Rump, 
    %       ``Faithfully rounded floating-point computations,'' 
    %       ACM Trans. Math. Softw., vol. 46, no. 3, p. 20, 2020.
    %
    %   In general, the results of CPair arithmetic are 
    %   more accurate than those of FP64 and 
    %   less accurate than double-double arithmetic. 
    %
    %   written ... 2024-08-03 ... UCHINO Yuki
    %
    methods (Static)

        function [c,g] = divide(a,e,b,f)
            c = a./b;
            p = fma(-b,c,a)+e;
            g = fma(-c,f,p)./(b+f);
            if nargout < 2
                c = c+g;
            end
        end

        function [c,g] = times(a,e,b,f)
            [c,g] = util.eft.TwoProd(a,b);
            g = g+fma(a,f,b.*e);
            if nargout < 2
                c = c+g;
            end
        end

        function [c,g] = sum(a,e)
            m = size(a,1);
            c = a(1,:);
            g = e(1,:);
            for i=2:m
                [c,g] = util.cpair.plus(c,g,a(i,:),e(i,:));
            end
            if nargout < 2
                c = c+g;
            end
        end

        function [c,g] = plus(a,e,b,f)
            [c,g] = util.eft.TwoSum(a,b);
            g = g + (e + f);
            if nargout < 2
                c = c+g;
            end
        end

        function [c,g] = minus(a,e,b,f)
            [c,g] = util.eft.TwoSum(a,-b);
            g = g + (e - f);
            if nargout < 2
                c = c+g;
            end
        end
        
    end
end