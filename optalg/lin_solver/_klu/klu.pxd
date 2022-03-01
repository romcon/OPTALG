
cdef extern from "klu.h":

    ctypedef struct klu_symbolic:
        pass

    ctypedef struct klu_numeric:
        pass
        
    ctypedef struct klu_common:
        pass

    klu_symbolic* klu_analyze(int n, int* Ap, int* Ai, klu_common *Common)

    klu_numeric* klu_factor(int* Ap, int* Ai, double* Ax, klu_symbolic *Symbolic, klu_common *Common) 

    int klu_solve(klu_symbolic *Symbolic, klu_numeric *Numeric, int ldim, int nrhs, double* B, klu_common *Common)

    int klu_refactor(int* Ap, int* Ai, double* Ax, klu_symbolic *Symbolic, klu_numeric *Numeric, klu_common *Common)

    int klu_defaults(klu_common *Common)

    int klu_free_symbolic(klu_symbolic **Symbolic, klu_common *Common)

    int klu_free_numeric(klu_numeric **Numeric, klu_common *Common) 
