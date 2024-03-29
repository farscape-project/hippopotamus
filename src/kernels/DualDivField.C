//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "DualDivField.h"
#include "Assembly.h"

registerMooseObject("MooseApp", DualDivField);

InputParameters
DualDivField::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Takes the divergence of a vector field, optionally "
                             "scaled by a constant scalar coefficient.");
  params.addRequiredCoupledVar("coupled_vector_variable", "The vector field");
  params.addParam<Real>("coeff", 1.0, "The constant coefficient");
  return params;
}

DualDivField::DualDivField(const InputParameters & parameters)
  : Kernel(parameters),
    _u_var(*getVectorVar("coupled_vector_variable", 0)),
    _u_var_num(coupled("coupled_vector_variable")),
    _coupled_u(_is_implicit ? _u_var.sln() : _u_var.slnOld()),
    _coupled_phi(_assembly.phi(_u_var)),
    _coeff(getParam<Real>("coeff"))
{
}

Real
DualDivField::computeQpResidual()
{
  return _coeff * _coupled_u[_qp] * _grad_test[_i][_qp];
}

Real
DualDivField::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_u_var_num == jvar)
    return _coeff * _coupled_phi[_j][_qp] * _grad_test[_i][_qp];

  return 0.0;
}
