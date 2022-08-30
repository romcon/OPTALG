import numpy as np
cimport numpy as np

from . cimport klu

np.import_array()

from scipy.sparse import csc_matrix

cdef extern from "numpy/arrayobject.h":
     void PyArray_ENABLEFLAGS(np.ndarray arr, int flags)
     void PyArray_CLEARFLAGS(np.ndarray arr, int flags)

cdef ArrayDouble(double* a, int size):
     cdef np.npy_intp shape[1]
     shape[0] = <np.npy_intp> size
     arr = np.PyArray_SimpleNewFromData(1,shape,np.NPY_DOUBLE,a)
     PyArray_CLEARFLAGS(arr,np.NPY_OWNDATA)
     return arr


cdef class kluSolver:
    cdef klu.klu_symbolic* _c_klu_symbolic
    cdef klu.klu_common _c_klu_common
    cdef klu.klu_numeric* _c_klu_numeric
    cdef bint alloc

    def __init__(self):
        pass

    
    def __cinit__(self):
        """
        Initialize paramaters
        """

        out = klu.klu_defaults(&(self._c_klu_common))
        assert out == 1

    def __dealloc__(self):
        """
        Frees C data structure.
        """
        if self._c_klu_numeric != NULL:
            klu.klu_free_numeric(&self._c_klu_numeric, &(self._c_klu_common))

        if self._c_klu_symbolic != NULL:
            klu.klu_free_symbolic(&self._c_klu_symbolic, &(self._c_klu_common))

    def analyze(self, A):
        """
        Analyze CSC sparse matrix A
        """
        
        A = csc_matrix(A)  # Just to be sure? If it is going to take time, ignore (It is the user responsibility to ensure A is sparse CSC matrix)
        m, n = A.shape
        
        cdef np.ndarray[int,mode='c'] Ap = A.indptr
        cdef np.ndarray[int,mode='c'] Ai = A.indices

        assert(Ap.size == (m+1))
        assert(Ap[m] == A.nnz)
        assert(Ai.size == A.nnz)

        self._c_klu_symbolic = klu.klu_analyze(n, 
                                               <int*>(Ap.data), 
                                               <int*>(Ai.data), 
                                               &(self._c_klu_common))

    def factorize(self, A):
        """
        Factorize CSC sparse matrix A
        """

        A = csc_matrix(A)

        cdef np.ndarray[int,mode='c'] Ap = A.indptr
        cdef np.ndarray[int,mode='c'] Ai = A.indices
        cdef np.ndarray[double,mode='c'] Ax = A.data

        m,n = A.shape
        assert(A.shape[1] == n)
        assert(Ap.size == (n+1))
        assert(Ap[n] == A.nnz)
        assert(Ai.size == A.nnz)
        assert(Ax.size == A.nnz)

        self._c_klu_numeric = klu.klu_factor(<int*>(Ap.data),  
                                             <int*>(Ai.data), 
                                             <double*>(Ax.data), 
                                             self._c_klu_symbolic, 
                                             &(self._c_klu_common)) 

    def solve(self, b):
        """
        Solve system of Equations Ax = b
        """

        ldim = b.shape[0]
        if len(b.shape) == 1:
            nrhs = 1
        else:
            nrhs = max(b.shape[1], 1) 

        cdef np.ndarray[double,mode='c'] B = b

        out = klu.klu_solve(self._c_klu_symbolic,
                            self._c_klu_numeric,
                            ldim, 
                            nrhs, 
                            <double*>(B.data), 
                            &(self._c_klu_common))

        return out
