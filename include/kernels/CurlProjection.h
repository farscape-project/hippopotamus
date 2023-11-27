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
class CurlProjection : public VectorKernel
{
public:
  static InputParameters validParams();

  CurlProjection(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  /// Function coefficient
  const Function & _function;

  VectorMooseVariable & _v_var;

    /// div of the shape function
  const VectorVariablePhiCurl & _curl_phi;


  /// Holds the solution dic at the current quadrature points
  const VectorVariableCurl & _curl_v;

  unsigned int _v_var_num;
};