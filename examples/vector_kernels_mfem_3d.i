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
[]

[AuxKernels]
  [a_x]
    type = FunctionAux
    variable = a_x
    function = '- pi * cos(pi*z)'
  []
  [a_y]
    type = FunctionAux
    variable = a_y
    function = '- pi * cos(pi*x)'
  []
  [a_z]
    type = FunctionAux
    variable = a_z
    function = '- pi * cos(pi*y)'
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

[Kernels]
  [curl_curl]
    type = CurlCurlField
    variable = u
  []
  [coeff]
    type = VectorFunctionReaction
    variable = u
  []
  [rhs]
    type = VectorBodyForce
    variable = u
    function_x = '(1.0 + pi * pi) * sin(pi*y)'
    function_y = '(1.0 + pi * pi) * sin(pi*z)'
    function_z = '(1.0 + pi * pi) * sin(pi*x)'
  []
  [curl_projection]
    type = CurlProjection
    variable = v
    u = u
  []
[]

[BCs]
  [sides]
    type = VectorCurlPenaltyDirichletBC
    variable = u
    function_x = 'sin(pi*y)'
    function_y = 'sin(pi*z)'
    function_z = 'sin(pi*x)'
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



[Postprocessors]
  [HDivError]
    type = ElementHDivError
    variable = v
    gradx_func_x = '0'
    grady_func_y = '0'
    gradz_func_z = '0'
    func_x = '- pi * cos(pi*z)'
    func_y = '- pi * cos(pi*x)'
    func_z = '- pi * cos(pi*y)'
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
petsc_options_iname = '-ksp_type -pc_type  -ksp_atol -ksp_rtol -ksp_divtol -ksp_norm_type -line_search'
  petsc_options_value = 'gmres   jacobi 1e-50  1e-12 10000  preconditioned   none '
  petsc_options = '-options_left    -snes_converged_reason -info'
[]

[Outputs]
  exodus = true
[]
