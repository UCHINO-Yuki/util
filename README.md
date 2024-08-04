# util
Namespace of utility functions and constants for MATLAB

```
+util/@aux    Auxiliary functions
+util/@cpair  Fast pair arithmetic
+util/@eft    Functions of error-free transformation
+util/@eval   Functions for evaluating accuracy
+util/@fl     Constants & Functions for floating-point operation
```

**[DDclass]([URL](https://github.com/UCHINO-Yuki/DDclass)) is required for eval.**

## Installation
To be accessible to MATLAB, the parent folder of the  ``+util`` folder must be on the path.
For example, put the ``+util`` folder under ``C:\Users\user\Documents\MATLAB``.

## Usage
Functions and constants always requires the full class name and the namespace as followings:
```
s = util.aux.randsvd(n,cnd,mode)        % generating singular values with the same distribution of the singular values od gallery('randsvd',n,cnd,mode).
ur = util.fl.u(class)                   % unit roundoff
[ch,cl] = util.cpair.times(ah,al,bh,bl) % cpair multiplication
err = util.eval.evderr(a,x,exactx,d,exactd,type)  % error in EVD
...
```

You can use ``import`` to omit  the full class name and the namespace (see [here](https://www.mathworks.com/help/matlab/ref/import.html)).

For functions and constants defined in ``+util/@fl``, the outputs are for double precision if the input ``class`` is omitted as following:
```
ur = util.fl.u % unit roundoff
```
