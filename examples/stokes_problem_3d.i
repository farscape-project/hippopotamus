
[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 6
    ny = 6
    nz = 6
    xmax =  1
    ymax =  1
    zmax =  1
    xmin = -1
    ymin = -1
    zmin = -1
    elem_type = HEX27
  []
[]


[Variables]
  [u]
    family = RAVIART_THOMAS
    order = FIRST
  []
  [p]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [stokes]
    type = StokesField
    variable = u
    p = p 
  []
  [divergence]
    type = DivergenceField
    variable = p
    v = u
    function = forcing_func
  []
[]


[Functions]
  # A ParsedFunction allows us to supply analytic expressions
  # directly in the input file
  [./forcing_func]
    type = ParsedFunction
     expression = '3.0*.5*pi*.5*pi*cos(.5*pi*x)*sin(.5*pi*y)*cos(.5*pi*z)'
    symbol_names = 'alpha'
    symbol_values = '1'
  [../]
[]

[BCs]
 active = 'sides'

  [sides]
    type = VectorDivergencePenaltyDirichletBC
    variable = u
    function_x = '.5*pi*sin(.5*pi*x)*sin(.5*pi*y)*cos(.5*pi*z)'
    function_y = '-.5*pi*cos(.5*pi*x)*cos(.5*pi*y)*cos(.5*pi*z)'
    function_z = ' .5*pi*cos(.5*pi*x)*sin(.5*pi*y)*sin(.5*pi*z)'
    penalty = 1e10
    boundary = 'left right top bottom'
  []
   [pin]
    type = DirichletBC
    variable = p
    value = 0.0
    boundary = 'left right top bottom'
  []
[]



[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = ' -pc_type '
  petsc_options_value = 'ksp'
 # petsc_options = '-ksp_view_pmat  -ksp_view_rhs -ksp_converged_reason'
[]

[Outputs]
  exodus = true
[]