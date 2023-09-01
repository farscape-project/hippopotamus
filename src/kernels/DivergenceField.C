//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "DivergenceField.h"
#include "Assembly.h"
#include "Function.h"

registerMooseObject("hippopotamusApp", DivergenceField);

InputParameters
DivergenceField::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Weak form term corresponding to $\\nabla \\times (a \\nabla \\times "
                             "\\vec{E})$.");
  params.addParam<FunctionName>("function", 1.0, "Function multiplier for diffusion term.");
  params.addRequiredCoupledVar("v", "velocity");
  return params;
}

DivergenceField::DivergenceField(const InputParameters & parameters)
  : Kernel(parameters),
    _function(getFunction("function")),
    _v_var(*getVectorVar("v", 0)),
    _div_test(_v_var.divPhi()),
    _div_phi(_assembly.divPhi(_v_var)),
    _div_v(_is_implicit ? _v_var.divSln() : _v_var.divSlnOld()),
    _v_var_num(coupled("v"))
{
}

Real
DivergenceField::computeQpResidual()
{
  //std::cout << _function.value(_t, _q_point[_qp]) << std::endl;
  if(_qp == 0)
  std::cout << "div_v = " << _div_v[_qp] << std::endl;
  return -_div_v[_qp] * _test[_i][_qp] + _function.value(_t, _q_point[_qp]) * _test[_i][_qp];
}

Real
DivergenceField::computeQpJacobian()
{
  return 0.0;
}

Real
DivergenceField::computeQpOffDiagJacobian(unsigned int jvar)
{
   // std::cout << "div_phi = " << _div_phi[_j][_qp] << std::endl;
  if (_v_var_num == jvar) 
    return  -_div_phi[_j][_qp] * _test[_i][_qp];
  
  return 0.0;
}
