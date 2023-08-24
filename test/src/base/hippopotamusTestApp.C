//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "hippopotamusTestApp.h"
#include "hippopotamusApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
hippopotamusTestApp::validParams()
{
  InputParameters params = hippopotamusApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

hippopotamusTestApp::hippopotamusTestApp(InputParameters parameters) : MooseApp(parameters)
{
  hippopotamusTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

hippopotamusTestApp::~hippopotamusTestApp() {}

void
hippopotamusTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  hippopotamusApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"hippopotamusTestApp"});
    Registry::registerActionsTo(af, {"hippopotamusTestApp"});
  }
}

void
hippopotamusTestApp::registerApps()
{
  registerApp(hippopotamusApp);
  registerApp(hippopotamusTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
hippopotamusTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  hippopotamusTestApp::registerAll(f, af, s);
}
extern "C" void
hippopotamusTestApp__registerApps()
{
  hippopotamusTestApp::registerApps();
}
