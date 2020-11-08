#****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2015-2017, Tomas Tinoco De Rubira.   #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
#****************************************************#

cdef extern from "coin/Cbc_C_Interface.h":

    ctypedef void Cbc_Model

    Cbc_Model* Cbc_newModel()
    void Cbc_deleteModel(Cbc_Model* model)

    void Cbc_loadProblem(Cbc_Model* model, int numcols, int numrows, int* start, int* index, double* value,
                         double* collb, double* colub, double* obj, double* rowlb, double* rowub)

    
    int Cbc_status(Cbc_Model* model)

    int Cbc_solve(Cbc_Model* model)
    
    int Cbc_getNumRows(Cbc_Model* model)
    int Cbc_getNumCols(Cbc_Model* model)
    
    void Cbc_setInteger(Cbc_Model* model, int iColumn)
    void Cbc_setParameter(Cbc_Model* model, char* name, char* value)

    double Cbc_getAllowableFractionGap(Cbc_Model *model)
    void Cbc_setAllowableFractionGap(Cbc_Model *model, double allowedFracionGap)

    double Cbc_getAllowablePercentageGap(Cbc_Model* model)
    void Cbc_setAllowablePercentageGap(Cbc_Model* model, double allowedPercentageGap)
    
    double Cbc_getMaximumSeconds(Cbc_Model *model)
    void Cbc_setMaximumSeconds(Cbc_Model *model, double maxSeconds)
    
    int Cbc_getMaximumNodes(Cbc_Model *model)
    void Cbc_setMaximumNodes(Cbc_Model *model, int maxNodes)
    
    int Cbc_getMaximumSolutions(Cbc_Model *model)
    void Cbc_setMaximumSolutions(Cbc_Model *model, int maxSolutions)

    double* Cbc_getColSolution(Cbc_Model* model)
    
    int Cbc_isProvenOptimal(Cbc_Model* model)
    int Cbc_isProvenInfeasible(Cbc_Model* model)
    
    int Cbc_getLogLevel(Cbc_Model *model);
    void Cbc_setLogLevel(Cbc_Model *model, int logLevel)
    
