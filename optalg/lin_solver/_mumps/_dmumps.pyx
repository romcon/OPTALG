"""
- Changed "long" to "unsigned long" (Tomas Tinoco De Rubira, 01/11/2014)
- Changed "unsigned long" to "uintptr_t" (Tamer Ibrahim, 04/19/2020)
- Separated variable definitions into multipler lines (Tomas Tinoco De Rubira, 06/02/2017)
"""

__all__ = ['DMUMPS_STRUC_C', 'dmumps_c', 'cast_array']

########################################################################
# libdmumps / dmumps_c.h wrappers (using Cython)
########################################################################

MUMPS_INT_DTYPE = 'i'
DMUMPS_REAL_DTYPE = 'd'
DMUMPS_COMPLEX_DTYPE = 'd'

from libc.string cimport strncpy
from libc.stdint cimport uintptr_t

cdef extern from "dmumps_c.h":

    ctypedef int MUMPS_INT
    ctypedef double DMUMPS_COMPLEX
    ctypedef double DMUMPS_REAL

    char* MUMPS_VERSION

    ctypedef struct c_DMUMPS_STRUC_C "DMUMPS_STRUC_C":
        MUMPS_INT      sym, par, job
        MUMPS_INT      comm_fortran    # Fortran communicator
        MUMPS_INT      icntl[40]
        DMUMPS_REAL    cntl[15]
        MUMPS_INT      n

        # used in matlab interface to decide if we
        # free + malloc when we have large variation
        MUMPS_INT      nz_alloc

        # Assembled entry
        MUMPS_INT      nz
        MUMPS_INT      *irn
        MUMPS_INT      *jcn
        DMUMPS_COMPLEX *a

        # Distributed entry
        MUMPS_INT      nz_loc
        MUMPS_INT      *irn_loc
        MUMPS_INT      *jcn_loc
        DMUMPS_COMPLEX *a_loc

        # Element entry
        MUMPS_INT      nelt
        MUMPS_INT      *eltptr
        MUMPS_INT      *eltvar
        DMUMPS_COMPLEX *a_elt

        # Ordering, if given by user
        MUMPS_INT      *perm_in

        # Orderings returned to user
        MUMPS_INT      *sym_perm    # symmetric permutation
        MUMPS_INT      *uns_perm    # column permutation

        # Scaling (input only in this version)
        DMUMPS_REAL    *colsca
        DMUMPS_REAL    *rowsca

        # RHS, solution, ouptput data and statistics
        DMUMPS_COMPLEX *rhs
        DMUMPS_COMPLEX *redrhs
        DMUMPS_COMPLEX *rhs_sparse
        DMUMPS_COMPLEX *sol_loc
        MUMPS_INT      *irhs_sparse 
        MUMPS_INT      *irhs_ptr
        MUMPS_INT      *isol_loc
        MUMPS_INT      nrhs
        MUMPS_INT      lrhs 
        MUMPS_INT      lredrhs 
        MUMPS_INT      nz_rhs 
        MUMPS_INT      lsol_loc
        MUMPS_INT      schur_mloc
        MUMPS_INT      schur_nloc
        MUMPS_INT      schur_lld
        MUMPS_INT      mblock
        MUMPS_INT      nblock
        MUMPS_INT      nprow
        MUMPS_INT      npcol
        MUMPS_INT      info[40]
        MUMPS_INT      infog[40]
        DMUMPS_REAL    rinfo[20]
        DMUMPS_REAL    rinfog[20]

        # Null space
        MUMPS_INT      deficiency
        MUMPS_INT      *pivnul_list
        MUMPS_INT      *mapping

        # Schur
        MUMPS_INT      size_schur
        MUMPS_INT      *listvar_schur
        DMUMPS_COMPLEX *schur

        # Internal parameters
        MUMPS_INT      instance_number
        DMUMPS_COMPLEX *wk_user

        char *version_number
        # For out-of-core
        char *ooc_tmpdir
        char *ooc_prefix
        # To save the matrix in matrix market format
        char *write_problem
        MUMPS_INT      lwk_user
    void c_dmumps_c "dmumps_c" (c_DMUMPS_STRUC_C *)

cdef class DMUMPS_STRUC_C:
    cdef c_DMUMPS_STRUC_C ob

    property sym:
        def __get__(self): return self.ob.sym
        def __set__(self, value): self.ob.sym = value
    property par:
        def __get__(self): return self.ob.par
        def __set__(self, value): self.ob.par = value
    property job:
        def __get__(self): return self.ob.job
        def __set__(self, value): self.ob.job = value

    property comm_fortran:
        def __get__(self): return self.ob.comm_fortran
        def __set__(self, value): self.ob.comm_fortran = value

    property icntl:
        def __get__(self):
            cdef MUMPS_INT[:] view = self.ob.icntl
            return view
    property cntl:
        def __get__(self):
            cdef DMUMPS_REAL[:] view = self.ob.cntl
            return view

    property n:
        def __get__(self): return self.ob.n
        def __set__(self, value): self.ob.n = value
    property nz_alloc:
        def __get__(self): return self.ob.nz_alloc
        def __set__(self, value): self.ob.nz_alloc = value

    property nz:
        def __get__(self): return self.ob.nz
        def __set__(self, value): self.ob.nz = value
    property irn:
        def __get__(self): return <uintptr_t> self.ob.irn
        def __set__(self, uintptr_t value): self.ob.irn = <MUMPS_INT*> value
    property jcn:
        def __get__(self): return <uintptr_t> self.ob.jcn
        def __set__(self, uintptr_t value): self.ob.jcn = <MUMPS_INT*> value
    property a:
        def __get__(self): return <uintptr_t> self.ob.a
        def __set__(self, uintptr_t value): self.ob.a = <DMUMPS_COMPLEX*> value

    property nz_loc:
        def __get__(self): return self.ob.nz_loc
        def __set__(self, value): self.ob.nz_loc = value
    property irn_loc:
        def __get__(self): return <uintptr_t> self.ob.irn_loc
        def __set__(self, uintptr_t value): self.ob.irn_loc = <MUMPS_INT*> value
    property jcn_loc:
        def __get__(self): return <uintptr_t> self.ob.jcn_loc
        def __set__(self, uintptr_t value): self.ob.jcn_loc = <MUMPS_INT*> value
    property a_loc:
        def __get__(self): return <uintptr_t> self.ob.a_loc
        def __set__(self, uintptr_t value): self.ob.a_loc = <DMUMPS_COMPLEX*> value

    property nelt:
        def __get__(self): return self.ob.nelt
        def __set__(self, value): self.ob.nelt = value
    property eltptr:
        def __get__(self): return <uintptr_t> self.ob.eltptr
        def __set__(self, uintptr_t value): self.ob.eltptr = <MUMPS_INT*> value
    property eltvar:
        def __get__(self): return <uintptr_t> self.ob.eltvar
        def __set__(self, uintptr_t value): self.ob.eltvar = <MUMPS_INT*> value
    property a_elt:
        def __get__(self): return <uintptr_t> self.ob.a_elt
        def __set__(self, uintptr_t value): self.ob.a_elt = <DMUMPS_COMPLEX*> value

    property perm_in:
        def __get__(self): return <uintptr_t> self.ob.perm_in
        def __set__(self, uintptr_t value): self.ob.perm_in = <MUMPS_INT*> value

    property sym_perm:
        def __get__(self): return <uintptr_t> self.ob.sym_perm
        def __set__(self, uintptr_t value): self.ob.sym_perm = <MUMPS_INT*> value
    property uns_perm:
        def __get__(self): return <uintptr_t> self.ob.uns_perm
        def __set__(self, uintptr_t value): self.ob.uns_perm = <MUMPS_INT*> value

    property colsca:
        def __get__(self): return <uintptr_t> self.ob.colsca
        def __set__(self, uintptr_t value): self.ob.colsca = <DMUMPS_REAL*> value
    property rowsca:
        def __get__(self): return <uintptr_t> self.ob.rowsca
        def __set__(self, uintptr_t value): self.ob.rowsca = <DMUMPS_REAL*> value

    property rhs:
        def __get__(self): return <uintptr_t> self.ob.rhs
        def __set__(self, uintptr_t value): self.ob.rhs = <DMUMPS_COMPLEX*> value
    property redrhs:
        def __get__(self): return <uintptr_t> self.ob.redrhs
        def __set__(self, uintptr_t value): self.ob.redrhs = <DMUMPS_COMPLEX*> value
    property rhs_sparse:
        def __get__(self): return <uintptr_t> self.ob.rhs_sparse
        def __set__(self, uintptr_t value): self.ob.rhs_sparse = <DMUMPS_COMPLEX*> value
    property sol_loc:
        def __get__(self): return <uintptr_t> self.ob.sol_loc
        def __set__(self, uintptr_t value): self.ob.sol_loc = <DMUMPS_COMPLEX*> value


    property irhs_sparse:
        def __get__(self): return <uintptr_t> self.ob.irhs_sparse
        def __set__(self, uintptr_t value): self.ob.irhs_sparse = <MUMPS_INT*> value
    property irhs_ptr:
        def __get__(self): return <uintptr_t> self.ob.irhs_ptr
        def __set__(self, uintptr_t value): self.ob.irhs_ptr = <MUMPS_INT*> value
    property isol_loc:
        def __get__(self): return <uintptr_t> self.ob.isol_loc
        def __set__(self, uintptr_t value): self.ob.isol_loc = <MUMPS_INT*> value

    property nrhs:
        def __get__(self): return self.ob.nrhs
        def __set__(self, value): self.ob.nrhs = value
    property lrhs:
        def __get__(self): return self.ob.lrhs
        def __set__(self, value): self.ob.lrhs = value
    property lredrhs:
        def __get__(self): return self.ob.lredrhs
        def __set__(self, value): self.ob.lredrhs = value
    property nz_rhs:
        def __get__(self): return self.ob.nz_rhs
        def __set__(self, value): self.ob.nz_rhs = value
    property lsol_loc:
        def __get__(self): return self.ob.lsol_loc
        def __set__(self, value): self.ob.lsol_loc = value

    property schur_mloc:
        def __get__(self): return self.ob.schur_mloc
        def __set__(self, value): self.ob.schur_mloc = value
    property schur_nloc:
        def __get__(self): return self.ob.schur_nloc
        def __set__(self, value): self.ob.schur_nloc = value
    property schur_lld:
        def __get__(self): return self.ob.schur_lld
        def __set__(self, value): self.ob.schur_lld = value


    property mblock:
        def __get__(self): return self.ob.mblock
        def __set__(self, value): self.ob.mblock = value
    property nblock:
        def __get__(self): return self.ob.nblock
        def __set__(self, value): self.ob.nblock = value
    property nprow:
        def __get__(self): return self.ob.nprow
        def __set__(self, value): self.ob.nprow = value
    property npcol:
        def __get__(self): return self.ob.npcol
        def __set__(self, value): self.ob.npcol = value

    property info:
        def __get__(self):
            cdef MUMPS_INT[:] view = self.ob.info
            return view
    property infog:
        def __get__(self):
            cdef MUMPS_INT[:] view = self.ob.infog
            return view

    property rinfo:
        def __get__(self):
            cdef DMUMPS_REAL[:] view = self.ob.rinfo
            return view
    property rinfog:
        def __get__(self):
            cdef DMUMPS_REAL[:] view = self.ob.rinfog
            return view

    property deficiency:
        def __get__(self): return self.ob.deficiency
        def __set__(self, value): self.ob.deficiency = value
    property pivnul_list:
        def __get__(self): return <uintptr_t> self.ob.pivnul_list
        def __set__(self, uintptr_t value): self.ob.pivnul_list = <MUMPS_INT*> value
    property mapping:
        def __get__(self): return <uintptr_t> self.ob.mapping
        def __set__(self, uintptr_t value): self.ob.mapping = <MUMPS_INT*> value

    property size_schur:
        def __get__(self): return self.ob.size_schur
        def __set__(self, value): self.ob.size_schur = value
    property listvar_schur:
        def __get__(self): return <uintptr_t> self.ob.listvar_schur
        def __set__(self, uintptr_t value): self.ob.listvar_schur = <MUMPS_INT*> value
    property schur:
        def __get__(self): return <uintptr_t> self.ob.schur
        def __set__(self, uintptr_t value): self.ob.schur = <DMUMPS_COMPLEX*> value

    property instance_number:
        def __get__(self): return self.ob.instance_number
        def __set__(self, value): self.ob.instance_number = value
    property wk_user:
        def __get__(self): return <uintptr_t> self.ob.wk_user
        def __set__(self, uintptr_t value): self.ob.wk_user = <DMUMPS_COMPLEX*> value

    property version_number:
        def __get__(self):
            return (<bytes> self.ob.version_number).decode('ascii')

    property ooc_tmpdir:
        def __get__(self):
            return (<bytes> self.ob.ooc_tmpdir).decode('ascii')
        def __set__(self, char *value):
            strncpy(self.ob.ooc_tmpdir, value, sizeof(self.ob.ooc_tmpdir))
    property ooc_prefix:
        def __get__(self):
            return (<bytes> self.ob.ooc_prefix).decode('ascii')
        def __set__(self, char *value):
            strncpy(self.ob.ooc_prefix, value, sizeof(self.ob.ooc_prefix))

    property write_problem:
        def __get__(self):
            return (<bytes> self.ob.write_problem).decode('ascii')
        def __set__(self, char *value):
            strncpy(self.ob.write_problem, value, sizeof(self.ob.write_problem))

    property lwk_user:
        def __get__(self): return self.ob.lwk_user
        def __set__(self, value): self.ob.lwk_user = value

def dmumps_c(DMUMPS_STRUC_C s not None):
    c_dmumps_c(&s.ob)

__version__ = (<bytes> MUMPS_VERSION).decode('ascii')

########################################################################
# Casting routines.
########################################################################

def cast_array(arr):
    """Convert numpy array to corresponding cffi pointer.

    The user is entirely responsible for ensuring the data is contiguous
    and for holding a reference to the underlying array.
    """
    dtype = arr.dtype
    if dtype == 'i':
        return arr.__array_interface__['data'][0]
    elif dtype == 'd':
        return arr.__array_interface__['data'][0]
    else:
        raise ValueError("Unknown dtype %r" % dtype)
