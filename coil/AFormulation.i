[Mesh]
  type = FileMesh
  file = tet14_vac_meshed_oval_coil_and_solid_target.e
[]

[Variables]
  [A]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[AuxVariables]
  [J]
    family = RAVIART_THOMAS
    order = FIRST
  []
  [V]
    order = SECOND
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
  [J]
    type = CoupledJExt
    variable = A
    Jext = J
    coeff = 1
    block = coil
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
  end_time = 0.25
  dt = 0.01
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [JCoil]
    type = TransientMultiApp
    input_files = JCoil.i
    execute_on = timestep_begin
  []
[]

[Transfers]
  [pull_current]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = JCoil

    # The name of the variable in the sub-app
    source_variable = J

    # The name of the auxiliary variable in this app
    variable = J
  []
  [pull_potential]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = JCoil

    # The name of the variable in the sub-app
    source_variable = V

    # The name of the auxiliary variable in this app
    variable = V
  []
[]
