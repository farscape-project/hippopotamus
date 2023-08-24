#include "hippopotamusApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
hippopotamusApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

hippopotamusApp::hippopotamusApp(InputParameters parameters) : MooseApp(parameters)
{
  hippopotamusApp::registerAll(_factory, _action_factory, _syntax);
}

hippopotamusApp::~hippopotamusApp() {}

void 
hippopotamusApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<hippopotamusApp>(f, af, s);
  Registry::registerObjectsTo(f, {"hippopotamusApp"});
  Registry::registerActionsTo(af, {"hippopotamusApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
hippopotamusApp::registerApps()
{
  registerApp(hippopotamusApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
hippopotamusApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  hippopotamusApp::registerAll(f, af, s);
}
extern "C" void
hippopotamusApp__registerApps()
{
  hippopotamusApp::registerApps();
}
