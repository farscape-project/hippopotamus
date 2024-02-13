//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "JouleHeatingAux.h"

registerMooseObject("hippopotamusApp", JouleHeatingAux);


InputParameters
JouleHeatingAux::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription(
      "Calculates the joule heating");
  params.addCoupledVar("electric_field", "electric field variable");
  return params;
}


JouleHeatingAux::JouleHeatingAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _electric_field(coupledVectorValue("electric_field")),
    _conductivity(getGenericMaterialProperty<Real,false>("electrical_conductivity"))   
{
 
}


Real
JouleHeatingAux::computeValue()
{
   return _conductivity[_qp] * (_electric_field[_qp] * _electric_field[_qp]);
}


