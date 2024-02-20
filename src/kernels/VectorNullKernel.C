//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "VectorNullKernel.h"

registerMooseObject("MooseApp", VectorNullKernel);

InputParameters
VectorNullKernel::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Kernel that sets a zero residual.");
  params.addParam<Real>(
      "jacobian_fill",
      1e-9,
      "On diagonal Jacobian fill term to retain an invertible matrix for the preconditioner");
  return params;
}

VectorNullKernel::VectorNullKernel(const InputParameters & parameters)
  : VectorKernel(parameters), _jacobian_fill(getParam<Real>("jacobian_fill"))
{
}

Real
VectorNullKernel::computeQpResidual()
{
  return 0.0;
}

Real
VectorNullKernel::computeQpJacobian()
{
  return _jacobian_fill;
}
