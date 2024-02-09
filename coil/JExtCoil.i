[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = vac_meshed_oval_coil_and_solid_target.e
  []
  second_order = true
[]

[Variables]
  [V]
  []
  [D]
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
    variable = D
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
    function = 5*cos(2*pi/.5*t)
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
  petsc_options_iname = '-pc_type -ksp_atol -ksp_rtol'
  petsc_options_value = 'hypre 1e-12 1e-20'
  #start_time = 0.0
  #dt = 0.05
  #end_time = 0.5
  num_steps = 1
[]

[Outputs]
  exodus = true
[]
