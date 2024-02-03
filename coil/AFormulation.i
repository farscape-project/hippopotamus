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
[]

[AuxVariables]
  [J]
    family = NEDELEC_ONE
    order = FIRST
  []
[]


[Kernels]

  [timederivative]
    type = VectorTimeDerivative
    variable = A
  []

  [curl_curl_target]
    type = CurlCurlField
    variable = A
    coeff = 0.1612903225e-7
    block = target
  []

  [curl_curl_coil]
    type = CurlCurlField
    variable = A
    coeff = 0.1612903225e-7
    block = coil
  []

  [curl_curl_air]
    type = CurlCurlField
    variable = A
    coeff = 15915.4950873
    block = vacuum_region
  []

  [Jext]
    type = CoupledJExt
    variable = A
    Jext = J
    coeff = 0.1612903225e-7
  []

[]



[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  start_time = 0.0
  end_time = 0.5
  dt = 0.05
  
[]

[Outputs]
  exodus = true
[]



[MultiApps]
  [sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = 'JExtCoil.i'
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

