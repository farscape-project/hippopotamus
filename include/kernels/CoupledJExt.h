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
class CoupledJExt : public VectorKernel
{
public:
  static InputParameters validParams();

  CoupledJExt(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

  VectorMooseVariable & _Jext_var;

  const VectorVariableValue & _Jext;

    /// Scalar coefficient
  Real _coeff;

};