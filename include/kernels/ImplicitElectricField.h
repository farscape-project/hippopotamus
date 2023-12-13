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
class ImplicitElectricField : public VectorKernel
{
public:
  static InputParameters validParams();

  ImplicitElectricField(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;


  /// curl of the test function
  const VectorVariableTestCurl & _curl_test;

  /// curl of the shape function
  const VectorVariablePhiCurl & _curl_phi;

  /// Holds the solution curl at the current quadrature points
  const VectorVariableCurl & _curl_u;


  /// The function for the x component
  const Function & _function_x;

  /// The function for the y component
  const Function & _function_y;

  /// The function for the z component
  const Function & _function_z;

  VectorMooseVariable & _b_var;

  const VectorVariableValue & _b;

  const VectorVariablePhiValue & _b_phi;

  unsigned int _b_var_num;
};