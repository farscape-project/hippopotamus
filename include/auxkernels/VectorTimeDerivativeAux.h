//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "AuxKernel.h"



class VectorTimeDerivativeAux : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  VectorTimeDerivativeAux(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

  /// Vector variable of electric field (calculated using full electromagnetic description)
  const VectorVariableValue & _magnetic_vector_potential_dot;

  const VectorVariableValue & _magnetic_vector_potential;

  VectorMooseVariable & _mv_var;

  const VectorVariableValue & _magnetic_vector_potential_old;

  /// Electrical conductivity (in S/m)
  const GenericMaterialProperty<Real,false> & _conductivity;
};

