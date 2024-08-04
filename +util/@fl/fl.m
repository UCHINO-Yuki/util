classdef fl
    % FL
    %
    %   Constants & Functions for floating-point operation
    %
    %   written ... 2024-08-03 ... UCHINO Yuki
    %

    properties (Constant, Access=private)
        u_s = eps('single') .* 0.5;
        u_d = eps('double') .* 0.5;
        invu_s = single(2.^24);
        invu_d = 2.^53;
        inv2u_s = single(2.^23);
        inv2u_d = 2.^52;
        one_plus_inv2u_s = single(1+2.^23);
        one_plus_inv2u_d = 1+2.^52;
        one_minus_u_s = 1-eps('single') .* 0.5;
        one_minus_u_d = 1-eps('double') .* 0.5;
        one_plus_2u_s = 1+eps('single');
        one_plus_2u_d = 1+eps('double');
        Smin_s = realmin('single') .* eps('single');
        Smin_d = realmin('double') .* eps('double');
        Fmax_s = realmax('single');
        Fmax_d = realmax('double');
        Fmin_s = realmin('single');
        Fmin_d = realmin('double');
    end
    
    methods (Static)

        function r = u(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "double"
                    r = util.fl.u_d;
                case "single"
                    r = util.fl.u_s;
            end
        end

        function r = invu(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.invu_s;
                otherwise
                    r = util.fl.invu_d;
            end
        end

        function r = inv2u(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.inv2u_s;
                otherwise
                    r = util.fl.inv2u_d;
            end
        end

        function r = one_plus_inv2u(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.one_plus_inv2u_s;
                otherwise
                    r = util.fl.one_plus_inv2u_d;
            end
        end

        function r = prec(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = 24;
                otherwise
                    r = 53;
            end
        end

        function r = one_minus_u(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.one_minus_u_s;
                otherwise
                    r = util.fl.one_minus_u_d;
            end
        end

        function r = one_plus_2u(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.one_plus_2u_s;
                otherwise
                    r = util.fl.one_plus_2u_d;
            end
        end

        function r = Smin(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.Smin_s;
                otherwise
                    r = util.fl.Smin_d;
            end
        end

        function r = Fmax(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.Fmax_s;
                otherwise
                    r = util.fl.Fmax_d;
            end
        end

        function r = Fmin(fl_class)
            arguments (Input)
                fl_class (1,1) string = "double"
            end
            switch fl_class
                case "single"
                    r = util.fl.Fmin_s;
                otherwise
                    r = util.fl.Fmin_d;
            end
        end

        function r = ufp(a)
            cl = underlyingType(a);
            p = util.fl.one_plus_inv2u(cl);
            q = p .* a;
            r = abs(q-q.*util.fl.one_minus_u(cl));
            idx = isnan(r);
            if any(idx,'all')
                r(idx) = util.fl.ufp(a(idx).*util.fl.u(cl)).*util.fl.invu(cl);
            end
        end

        function a = ulp(a)
            cl = underlyingType(a);
            idx = abs(a) > util.fl.Fmin(cl);
            a(idx) = util.fl.ufp(eps(cl) .* a(idx));
            a(~idx & a~=0) = util.fl.Smin(cl);
        end

        function a = np2(a)
            idx = a==0;
            a = pow2(nextpow2(a));
            a(idx) = 0;
        end

        function v = ulnp(v)
            p = 63-floor(log2(abs(v)));
            v = pow2(v,p);
            v = pow2(bitand(v,-v,'int64'),-p);
        end

        function n = numbits(v)
            p = 63-floor(log2(abs(v)));
            v = pow2(v,p);
            n = 53-log2(bitand(v,-v,'int64'));
            n(~isfinite(n)) = 0;
        end

        function a = succ(a)
            a = a.*util.fl.one_plus_2u(underlyingType(a));
        end

        function a = pred(a)
            a = a.*util.fl.one_minus_u(underlyingType(a));
        end

    end
end