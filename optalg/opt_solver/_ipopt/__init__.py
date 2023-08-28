#****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2015-2017, Tomas Tinoco De Rubira.   #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
#****************************************************#

import sys
if sys.platform[:3].lower() == "win":
    import ctypes as cts
    import os
    cts.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)), "IpOptFSS.dll"), winmode=0)
    cts.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)), "IpOpt-vc10.dll"), winmode=0)

from .cipopt import *

