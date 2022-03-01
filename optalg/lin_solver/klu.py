#
# Question to Adam, should we use the same license header, even though it wasn't originally in OPTALG


from .lin_solver import LinSolver


class LinSolverKLU(LinSolver):
    """
    Linear solver based on SuperLU.
    """

    def __init__(self, prop='unsymmetric'):
        """
        Linear solver based on KLU.
        """

        # Parent
        LinSolver.__init__(self, prop)

        # Name
        self.name = 'klu'

        # Import klu
        from ._klu import kluSolver

        self.klusolver = kluSolver()

    def analyze(self, A):
        """
        Analyzes structure of A.

        Parameters
        ----------

        A : matrix
           For symmetric systems, should contain only lower diagonal part.
        """

        self.klusolver.analyze(A)

    def factorize(self, A):
        """
        Factorizes A.

        Parameters
        ----------
        A : matrix
           For symmetric systems, should contain only lower diagonal part.
        """

        self.klusolver.factorize(A)

    def solve(self, b):
        """
        Solves system Ax=b.

        Parameters
        ----------
        b : ndarray

        Returns
        -------
        x : ndarray
        """

        x = b.copy()
        self.klusolver.solve(x)

        return x
