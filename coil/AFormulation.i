[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = vac_meshed_oval_coil_and_solid_target.e
  []
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
  [J]
    family = NEDELEC_ONE
    order = FIRST
  []
  [E]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

# Electrical conductivity/resistivity from
# https://en.wikipedia.org/wiki/Electrical_resistivity_and_conductivity
[Kernels]
  [curl_curl_coil]
    type = CurlCurlField
    variable = A
    coeff = 1
    block = coil
  []
  [curl_curl_target]
    variable = A
    type = CurlCurlField
    coeff = 1
    block = target
  []
  [curl_curl_air]
    type = CurlCurlField
    variable = A
    coeff = 1e8
    block = vacuum_region
  []
#------------------------------
  [timederivative]
    type = VectorTimeDerivative
    variable = A
  []
#------------------------------
  [Jext]
    type = CoupledJExt
    variable = A
    Jext = J
    coeff = 1
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
  end_time = 0.2
  dt = 0.01
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = JExtCoil.i
    execute_on = timestep_begin
  []
[]

[Transfers]
  [pull_jext]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = sub_app

    # The name of the variable in the sub-app
    source_variable = J

    # The name of the auxiliary variable in this app
    variable = J
  []
[]
