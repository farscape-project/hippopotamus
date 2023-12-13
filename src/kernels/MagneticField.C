//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "MagneticField.h"
#include "Assembly.h"
#include "Function.h"

registerMooseObject("hippopotamusApp", MagneticField);

InputParameters
MagneticField::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Weak form term corresponding to $\\nabla \\times (a \\nabla \\times "
                             "\\vec{E})$.");
  params.addRequiredCoupledVar("e", "electric_field");
  return params;
}

MagneticField::MagneticField(const InputParameters & parameters)
  : VectorKernel(parameters),
    _u_old(_var.slnOld()),
    _e_var(*getVectorVar("e", 0)),
    _curl_e(_e_var.curlSln()),
    _curl_phi(_assembly.curlPhi(_e_var)),
    _e_var_num(coupled("e"))
{
}

Real
MagneticField::computeQpResidual()
{
  return (_u[_qp] - _u_old[_qp]) * _test[_i][_qp] + _dt * _curl_e[_qp] * _test[_i][_qp];
}

Real
MagneticField::computeQpJacobian()
{
  return _phi[_j][_qp] * _test[_i][_qp];
}

Real
MagneticField::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_e_var_num == jvar) 
    return  _dt * _curl_phi[_j][_qp] * _test[_i][_qp];
  
  return 0.0;
}
