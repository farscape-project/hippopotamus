[Mesh]
  type = FileMesh
  file = vac_meshed_oval_coil_and_solid_target.e
  second_order = true
[]

[Variables]
  [V]
  []
[]

[AuxVariables]
  [J]
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
[]

[AuxKernels]
  [current_density]
    type = CurrentDensity
    variable = J
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

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = lu
  num_steps = 1
[]
