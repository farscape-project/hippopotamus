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

  [curl_curl]
    type = CurlCurlField
    variable = A
    coeff = 1.0
  []

  [Jext]
    type = CoupledJExt
    variable = A
    Jext = J
    coeff = 1.0
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

