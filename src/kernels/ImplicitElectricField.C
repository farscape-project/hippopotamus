//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ImplicitElectricField.h"
#include "Assembly.h"
#include "Function.h"

registerMooseObject("hippopotamusApp", ImplicitElectricField);

InputParameters
ImplicitElectricField::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Weak form term corresponding to $\\nabla \\times (a \\nabla \\times "
                             "\\vec{E})$.");
  params.addParam<FunctionName>("function_x", 0, "The function for the x component");
  params.addParam<FunctionName>("function_y", 0, "The function for the y component");
  params.addParam<FunctionName>("function_z", 0, "The function for the z component");
  params.addRequiredCoupledVar("b", "magnetic_field");
  return params;
}

ImplicitElectricField::ImplicitElectricField(const InputParameters & parameters)
  : VectorKernel(parameters),
    _curl_test(_var.curlPhi()),
    _curl_phi(_assembly.curlPhi(_var)),
    _curl_u(_var.curlSln()),
    _function_x(getFunction("function_x")),
    _function_y(getFunction("function_y")),
    _function_z(getFunction("function_z")),
    _b_var(*getVectorVar("b", 0)),
    _b(_b_var.sln()),
    _b_phi(_assembly.phi(_b_var)),
    _b_var_num(coupled("b"))
{
}

Real
ImplicitElectricField::computeQpResidual()
{
    RealVectorValue j_exact;

    j_exact = {_function_x.value(_t, _q_point[_qp]),
               _function_y.value(_t, _q_point[_qp]),
               _function_z.value(_t, _q_point[_qp])};

   // std::cout << j_exact(0) << " "  << j_exact(1) << "  " << j_exact([2]) << std::endl;

  return _b[_qp] * _curl_test[_i][_qp] - _u[_qp] * _test[_i][_qp] - j_exact * _test[_i][_qp];
}

Real
ImplicitElectricField::computeQpJacobian()
{
  return -_phi[_j][_qp] * _test[_i][_qp];
}

Real
ImplicitElectricField::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_b_var_num == jvar) 
    return  _b_phi[_j][_qp] * _curl_test[_i][_qp];
  
  return 0.0;
}
