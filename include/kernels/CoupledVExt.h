//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "VectorKernel.h"

/**
 *  Weak form contribution corresponding to -k*grad(p)
 */
class CoupledVExt : public VectorKernel
{
public:
  static InputParameters validParams();

  CoupledVExt(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  /// coupled scalar variable
  MooseVariable & _p_var;
  unsigned int _p_var_num;

  const VariableGradient & _grad_p;

  /// scalar coefficient
  Real _coeff;
};
