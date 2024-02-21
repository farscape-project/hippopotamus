[Mesh]
  type = FileMesh
  file = tet14_vac_meshed_oval_coil_and_solid_target.e
[]

[Variables]
  [J]
    family = RAVIART_THOMAS
    order = FIRST
  []
[]

[AuxVariables]
  [V]
    order = SECOND
  []
  [Jaux]
    family = RAVIART_THOMAS
    order = FIRST
  []
[]

[Kernels]
  [J]
    type = VectorFunctionReaction
    variable = J
    block = coil
  []
  [gradV]
    type = CoupledVExt
    variable = J
    coupled_scalar_variable = V
    block = coil
  []
  [null]
    type = VectorNullKernel
    variable = J
    block = 'target vacuum_region'
  []
[]

[AuxKernels]
  [current_density]
    type = CurrentDensity
    variable = Jaux
    potential = V
    block = coil
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

[Functions]
  [f]
    type = ParsedVectorFunction
  []
[]

[Postprocessors]
  [HDivSemiErrorAux]
    type = ElementHDivSemiError
    variable = Jaux
    function = f
  []
  [HDivSemiError]
    type = ElementHDivSemiError
    variable = J
    function = f
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = none
  #num_steps = 1
  start_time = 0.0
  end_time = 0.5
  dt = 0.05
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [VCoil]
    type = TransientMultiApp
    input_files = VCoil.i
    execute_on = timestep_begin
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer

    # Transfer from the sub-app to this app
    from_multi_app = VCoil

    # The name of the variable in the sub-app
    source_variable = V

    # The name of the auxiliary variable in this app
    variable = V
  []
[]
