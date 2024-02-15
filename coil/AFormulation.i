[Mesh]
  type = FileMesh
  file = vac_meshed_oval_coil_and_solid_target.e
  second_order = true
[]

[Variables]
  [A]
    family = NEDELEC_ONE
    order = FIRST
  []
  [B]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[AuxVariables]
  [V]
  []
  [E]
    family = NEDELEC_ONE
    order = FIRST
  []
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
[]

# Electrical conductivity/resistivity from
# https://en.wikipedia.org/wiki/Electrical_resistivity_and_conductivity
[Kernels]
  [curl_curl_conductors]
    type = CurlCurlField
    variable = A
    coeff = 1
    block = 'coil target'
  []
  [curl_curl_air]
    type = CurlCurlField
    variable = A
    coeff = 1
    block = vacuum_region
  []
#------------------------------
  [timederivative]
    type = VectorTimeDerivative
    variable = A
  []
#------------------------------
  [V]
    type = CoupledVExt
    variable = A
    coupled_scalar_variable = V
    coeff = 1
    block = coil
  []
#------------------------------
  [B]
    type = CurlProjection
    variable = B
    u = A
  []
[]

[AuxKernels]
  [electric_field]
    type = VectorTimeDerivativeAux
    variable = E
    magnetic_vector_potential = A
    execute_on = timestep_end
  []
  [joule_heating]
    type = JouleHeatingAux
    variable = P
    electric_field = E
    execute_on = timestep_end
  []
[]

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names = electrical_conductivity
    prop_values = 1
  []
[]

[BCs]
  [plane]
    type = VectorCurlPenaltyDirichletBC
    variable = A
    boundary = 'terminal_face coil_in coil_out'
    penalty = 1e8
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = '-pc_type -ksp_atol -ksp_rtol'
  petsc_options_value = 'lu 1e-12 1e-20'
  start_time = 0.0
  end_time = 0.5
  dt = 0.01
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    input_files = Jext.i
    execute_on = timestep_begin
  []
[]

[Transfers]
  [pull_jext]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = sub_app

    # The name of the variable in the sub-app
    source_variable = V

    # The name of the auxiliary variable in this app
    variable = V
  []
[]
