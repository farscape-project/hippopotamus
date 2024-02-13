//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "VectorTimeDerivativeAux.h"

registerMooseObject("hippopotamusApp", VectorTimeDerivativeAux);


InputParameters
VectorTimeDerivativeAux::validParams()
{
  InputParameters params = VectorAuxKernel::validParams();
  params.addClassDescription(
      "Calculates vector time derivatives");
  params.addCoupledVar("magnetic_vector_potential", "Magnetic vector potential variable");
  return params;
}


VectorTimeDerivativeAux::VectorTimeDerivativeAux(const InputParameters & parameters)
  : VectorAuxKernel(parameters),
    _magnetic_vector_potential_dot(coupledVectorDot("magnetic_vector_potential")),
    _magnetic_vector_potential(coupledVectorValue("magnetic_vector_potential")),
    _mv_var(*getVectorVar("magnetic_vector_potential", 0)),
    _magnetic_vector_potential_old(_mv_var.slnOld()),
    _conductivity(getGenericMaterialProperty<Real,false>("electrical_conductivity"))   
{
 
}


RealVectorValue
VectorTimeDerivativeAux::computeValue()
{
   //std::cout << _magnetic_vector_potential[_qp]  << "  " << _magnetic_vector_potential_old[_qp]  << std::endl;
   return -_conductivity[_qp] * (_magnetic_vector_potential[_qp] - _magnetic_vector_potential_old[_qp])/_dt;
}


