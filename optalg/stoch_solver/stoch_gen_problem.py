#****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2015, Tomas Tinoco De Rubira.        #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
#****************************************************#

class StochGen_Problem:
    """
    Represents a stochastic optimization problem 
    of the form
    
    minimize(x)   E[F(x,w)]
    subject to    E[G(x,w)] <= 0
                  x in X
    """

    def eval_FG(self,x,w):

        pass

    def eval_EFG(self,x):

        pass

    def get_size_x(self):

        pass

    def project_on_X(self,x):
        
        pass

    def sample_w(self):

        pass
        
    def show(self):

        pass
