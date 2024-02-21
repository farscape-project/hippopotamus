[Mesh]
  type = FileMesh
  file = tet14_vac_meshed_oval_coil_and_solid_target.e
[]

[Variables]
  [V]
    order = SECOND
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

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = hypre
  num_steps = 1
[]
