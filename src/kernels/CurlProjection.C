//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CurlProjection.h"
#include "Assembly.h"
#include "Function.h"

registerMooseObject("hippopotamusApp", CurlProjection);

InputParameters
CurlProjection::validParams()
{
  InputParameters params = VectorKernel::validParams();
  params.addClassDescription("Weak form term corresponding to $\\nabla \\times (a \\nabla \\times "
                             "\\vec{E})$.");
  params.addParam<FunctionName>("function", 1.0, "Function multiplier for diffusion term.");
  params.addRequiredCoupledVar("u", "velocity");
  return params;
}

CurlProjection::CurlProjection(const InputParameters & parameters)
  : VectorKernel(parameters),
    _function(getFunction("function")),
    _v_var(*getVectorVar("u", 0)),
    _curl_phi(_assembly.curlPhi(_v_var)),
    _curl_v(_v_var.curlSln()),
    _v_var_num(coupled("u"))
{
}

Real
CurlProjection::computeQpResidual()
{
   // std::cout <<  "_curl_v = " << _curl_v[_qp] << std::endl;
   // std::cout <<  "_u = " << _u[_qp] << std::endl;
   // std::cout <<  "_test = " << _test[_i][_qp] << std::endl;
  return  _u[_qp] * _test[_i][_qp] - _curl_v[_qp] * _test[_i][_qp];

}

Real
CurlProjection::computeQpJacobian()
{
  return _phi[_j][_qp] * _test[_i][_qp];
}

Real
CurlProjection::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_v_var_num == jvar) 
  {
     // std::cout <<  "_curl_phi = " << _curl_phi[_j][_qp] << std::endl;
    return  -_curl_phi[_j][_qp] * _test[_i][_qp];
  }
  
  return 0.0;
}
