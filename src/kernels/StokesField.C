//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "StokesField.h"
#include "Assembly.h"

registerMooseObject("hippopotamusApp", StokesField);

InputParameters
StokesField::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Weak form term corresponding to $\\nabla \\times (a \\nabla \\times "
                             "\\vec{E})$.");
  params.addParam<Real>("coeff", 1.0, "Weak form coefficient (default = 1.0).");
  params.addRequiredCoupledVar("p", "pressure");
  return params;
}

StokesField::StokesField(const InputParameters & parameters)
  : VectorKernel(parameters),
    _p(coupledValue("p")),
    _p_var(*getVar("p", 0)),
    _p_test(_p_var.phi()),
    _p_phi(_assembly.phi(_p_var)),
    _div_test(_var.divPhi()),
    _div_phi(_assembly.divPhi(_var)),
    _div_v(_is_implicit ? _var.divSln() : _var.divSlnOld()),
    _coeff(getParam<Real>("coeff")),
    _p_var_num(coupled("p"))
{
}

Real
StokesField::computeQpResidual()
{
  return _coeff * _u[_qp] * _test[_i][_qp] - _p[_qp] * _div_test[_i][_qp];
}

Real
StokesField::computeQpJacobian()
{
  return _coeff * _phi[_j][_qp] * _test[_i][_qp];
}

Real
StokesField::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_p_var_num == jvar) 
    return  -_p_phi[_j][_qp] * _div_test[_i][_qp];
  
  return 0.0;
}

