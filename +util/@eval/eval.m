classdef eval
    % EVAL
    %
    %   Functions for evaluating accuracy
    %
    %   written ... 2024-08-04 ... UCHINO Yuki
    %

    methods (Static)

        function r = XX_I(x)
            arguments (Input)
                x (:,:) dd
            end
            r = double(x'*x-eye(size(x,2)));
        end

        function r = XBX_I(x,b)
            arguments (Input)
                x (:,:) dd
                b (:,:) dd
            end
            r = double(x'*b*x-eye(size(x,2)));
        end

        function r = AX_XD(a,x,d)
            arguments (Input)
                a (:,:) dd
                x (:,:) dd
                d (:,:) dd
            end
            if isrow(d)
                r = double(a*x-x.*d);
            elseif iscolumn(d)
                r = double(a*x-x.*d.');
            else
                r = double(a*x-x*d);
            end
        end

        function r = AX_BXD(a,b,x,d)
            arguments (Input)
                a (:,:) dd
                b (:,:) dd
                x (:,:) dd
                d (:,:) dd
            end
            if isrow(d)
                r = double(a*x-b*x.*d);
            elseif iscolumn(d)
                r = double(a*x-b*x.*d.');
            else
                r = double(a*x-b*x*d);
            end
        end

        function r = B_AX(b,a,x)
            arguments (Input)
                b (:,:) dd
                a (:,:) dd
                x (:,:) dd
            end
            r = double(b-a*x);
        end

        function a = relerr(a,b)
            arguments (Input)
                a (:,:) dd
                b (:,:) dd
            end
            a = double((a-b)./b);
        end

        function err = evderr(a,x,exactx,d,exactd,type)
            % err := [ type(X'*X-I), type(A*X-X*D), type((D-eD)./eD), type((X-eX)./eX) ]
            % type in {"max",
            %          "median",
            %          "mean",
            %          "min",
            %          1,       % 1-norm
            %          2        % 2-norm
            %          Inf,     % infinity-norm
            %          "fro"}   % frobenius-norm
            arguments (Input)
                a       (:,:) dd
                x       (:,:) dd
                exactx  (:,:) dd
                d       (:,:) dd
                exactd  (:,:) dd
                type    (1,1) string = "max"
            end
            switch type
                case "max"
                    f = @(in) max(abs(in),[],'all');
                case "median"
                    f = @(in) median(abs(in),'all');
                case "mean"
                    f = @(in) mean(abs(in),'all');
                case "min"
                    f = @(in) min(abs(in),[],'all');
                case "1"
                    f = @(in) norm(in,1);
                case "2"
                    f = @(in) norm(in,2);
                case "Inf"
                    f = @(in) norm(in,inf);
                case "fro"
                    f = @(in) norm(in,"fro");
                otherwise
                    error('invalid input');
            end
            e1 = util.eval.XX_I(x);
            e2 = util.eval.AX_XD(a,x,d);
            e3 = util.eval.relerr(d,exactd);
            e4 = util.eval.relerr(x,exactx);
            err = [f(e1) f(e2) f(e3) f(e4)];
        end

        function err = gevderr(a,b,x,exactx,d,exactd,type)
            % err := [ type(X'*X-I), type(A*X-X*D), type((D-eD)./eD), type((X-eX)./eX) ]
            % type in {"max",
            %          "median",
            %          "mean",
            %          "min",
            %          1,       % 1-norm
            %          2        % 2-norm
            %          Inf,     % infinity-norm
            %          "fro"}   % frobenius-norm
            arguments (Input)
                a       (:,:) dd
                b       (:,:) dd
                x       (:,:) dd
                exactx  (:,:) dd
                d       (:,:) dd
                exactd  (:,:) dd
                type    (1,1) string = "max"
            end
            switch type
                case "max"
                    f = @(in) max(abs(in),[],'all');
                case "median"
                    f = @(in) median(abs(in),'all');
                case "mean"
                    f = @(in) mean(abs(in),'all');
                case "min"
                    f = @(in) min(abs(in),[],'all');
                case "1"
                    f = @(in) norm(in,1);
                case "2"
                    f = @(in) norm(in,2);
                case "Inf"
                    f = @(in) norm(in,inf);
                case "fro"
                    f = @(in) norm(in,"fro");
                otherwise
                    error('invalid input');
            end
            e1 = util.eval.XBX_I(x,b);
            e2 = util.eval.AX_BXD(a,b,x,d);
            e3 = util.eval.relerr(d,exactd);
            e4 = util.eval.relerr(x,exactx);
            err = [f(e1) f(e2) f(e3) f(e4)];
        end

        function errflag = errcheck(func,in)
            % func is a Function Handle, e.g.,
            %   for a*b,   use like errcheck(@(x)x{1}*x{2}     , a, b)
            %   for a-b*c, use like errcheck(@(x)x{1}-x{2}*x{3}, a, b, c)
            %
            % errflag = false => error-free!

            arguments (Input)
                func function_handle
            end
            arguments (Input, Repeating)
                in (:,:) double
            end

            feature('setround',inf);
            C = func(in{:});

            feature('setround',-inf);
            D = func(in{:});

            feature('setround',0.5);
            errflag = ~isequal(C,D);
        end

    end
end
