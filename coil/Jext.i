[Mesh]
  type = FileMesh
  file = vac_meshed_oval_coil_and_solid_target.e
  second_order = true
[]

[Variables]
  [V]
  []
  [J]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[AuxVariables]
  [Jaux]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = V
    block = coil
  []
  [null]
    type = NullKernel
    variable = V
    block = 'target vacuum_region'
  []

  [gradV]
    type = CoupledVExt
    variable = J
    coupled_scalar_variable = V
    block = coil
  []
  [J]
    type = VectorFunctionReaction
    variable = J
    #block = coil
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

[BCs]
  [left]
    type = DirichletBC
    variable = V
    boundary = coil_out
    value = 0
  []
  [right]
    type = FunctionDirichletBC
    variable = V
    boundary = coil_in
    function = 5*(1-cos(2*pi/.5*t))
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
  [HCurlSemiErrorAux]
    type = ElementHCurlSemiError
    variable = Jaux
    function = f
  []
  [HCurlSemiError]
    type = ElementHCurlSemiError
    variable = J
    function = f
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = lu
  num_steps = 1
  #start_time = 0.0
  #end_time = 0.5
  #dt = 0.05
[]

[Outputs]
  #exodus = true
[]
