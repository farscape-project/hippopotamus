//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoupledJExt.h"
#include "Assembly.h"
#include "Function.h"

registerMooseObject("hippopotamusApp", CoupledJExt);

InputParameters
CoupledJExt::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Weak form term corresponding to $\\nabla \\times (a \\nabla \\times "
                             "\\vec{E})$.");
  params.addRequiredCoupledVar("Jext", "current_density");
  params.addParam<Real>("coeff", 1.0, "Weak form coefficient (default = 1.0).");
  return params;
}

CoupledJExt::CoupledJExt(const InputParameters & parameters)
  : VectorKernel(parameters),
    _Jext_var(*getVectorVar("Jext", 0)),
    _Jext(_Jext_var.sln()),
    _coeff(getParam<Real>("coeff"))
{
}

Real
CoupledJExt::computeQpResidual()
{
  return  -_coeff * _Jext[_qp] * _test[_i][_qp];
}

Real
CoupledJExt::computeQpJacobian()
{
  return 0.0;
}


