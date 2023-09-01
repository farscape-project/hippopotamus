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
 *  Weak form contribution corresponding to the curl(curl(E)) where E is the
 *  electric field vector
 */
class StokesField : public VectorKernel
{
public:
  static InputParameters validParams();

  StokesField(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  const VariableValue & _p;

  MooseVariable & _p_var;

  const VariableTestValue & _p_test;

  const VariablePhiValue & _p_phi;

  /// div of the test function
  const VectorVariableTestDivergence & _div_test;

  /// div of the shape function
  const VectorVariablePhiDivergence & _div_phi;

  /// Holds the solution dic at the current quadrature points
  const VectorVariableDivergence & _div_v;

  /// Scalar coefficient
  Real _coeff;

  unsigned int _p_var_num;
};