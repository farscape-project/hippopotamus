# Test for EM module vector kernels CurlCurlField and VectorFunctionReaction
# Manufactured solution: u = y * x_hat - x * y_hat

[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 20
    ny = 20
    nz = 20
    xmin = -1
    ymin = -1
    zmin = -1
    elem_type = HEX27
  []
[]


[AuxVariables]
  [a_x]
  []
  [a_y]
  []
  [a_z]
  []

  [b_x]
  []
  [b_y]
  []
  [b_z]
  []
[]

[AuxKernels]
  [a_x]
    type = FunctionAux
    variable = a_x
    function = '(0.2/pi)*exp(-0.2*t)*sin(pi*y)'
  []
  [a_y]
    type = FunctionAux
    variable = a_y
    function = '(0.2/pi)*exp(-0.2*t)*sin(pi*z)'
  []
  [a_z]
    type = FunctionAux
    variable = a_z
    function = '(0.2/pi)*exp(-0.2*t)*sin(pi*x)'
  []


  [b_x]
    type = FunctionAux
    variable = b_x
    function = '(1.0-exp(-0.2*t))*cos(pi*z)'
  []
  [b_y]
    type = FunctionAux
    variable = b_y
    function = '(1.0-exp(-0.2*t))*cos(pi*x)'
  []
  [b_z]
    type = FunctionAux
    variable = b_z
    function = '(1.0-exp(-0.2*t))*cos(pi*y)'
  []

[]



[Variables]

  [u]
    family = NEDELEC_ONE
    order = FIRST
  []
  [v]
    family = RAVIART_THOMAS
    order = FIRST
  []
[]

[ICs]
active = ' '
  [./ic_v]
    type = ConstantIC
    variable = v
    value = 0.0
  [../]
[]

[Kernels]

  [curl_curl]
    type = ImplicitElectricField
    variable = u
    b = v
    function_x = '( (-pi * (1.0 - exp(-0.2*t))) - ((0.2/pi) * exp(-0.2*t)) ) * sin(pi*y)'
    function_y = '( (-pi * (1.0 - exp(-0.2*t))) - ((0.2/pi) * exp(-0.2*t)) ) * sin(pi*z)'
    function_z = '( (-pi * (1.0 - exp(-0.2*t))) - ((0.2/pi) * exp(-0.2*t)) ) * sin(pi*x)'
  []
  [coeff]
    type = MagneticField
    variable = v
    e = u
  []
 
[]

[BCs]

  [sides]
    type = VectorCurlPenaltyDirichletBC
    variable = u
    function_x = '(0.2/pi)*exp(-0.2*t)*sin(pi*y)'
    function_y = '(0.2/pi)*exp(-0.2*t)*sin(pi*z)'
    function_z = '(0.2/pi)*exp(-0.2*t)*sin(pi*x)'
    penalty = 1e8
    boundary = 'left right top bottom front back'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

#[Problem]
#  solve = False
#  type = FEProblem
#[]

[Executioner]
  type =  Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-ksp_type -pc_type  -ksp_atol -ksp_rtol -ksp_divtol -ksp_norm_type -line_search'
  petsc_options_value = 'gmres   jacobi 1e-50  1e-16 1000  preconditioned   none '
  petsc_options = '-options_left    -snes_converged_reason -info'

  num_steps       = 40
  dt              = 0.5
[]



[Outputs]
  exodus = true
[]