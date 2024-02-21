k = asin(1)

[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = -1
  ymin = -1
  xmax =  1
  ymax =  1
  nx = 40
  ny = 40
  elem_type = QUAD9
[]

[Functions]
  [f]
    type = ParsedVectorFunction
    expression_x =  ${k}*sin(${k}*x)*sin(${k}*y)*cos(${k}*z)
    expression_y = -${k}*cos(${k}*x)*cos(${k}*y)*cos(${k}*z)
    expression_z =  ${k}*cos(${k}*x)*sin(${k}*y)*sin(${k}*z)
    div = ${Mesh/dim}*${k}^2*cos(${k}*x)*sin(${k}*y)*cos(${k}*z)
  []
[]

[Variables]
  [V]
    family = LAGRANGE
    order = SECOND
  []
  [J]
    family = RAVIART_THOMAS
    order = FIRST
  []
[]

[AuxVariables]
  [Jaux]
    family = RAVIART_THOMAS
    order = FIRST
  []
[]

[Kernels]
  [J]
    type = VectorFunctionReaction
    variable = J
  []
  [gradV]
    type = CoupledVExt
    variable = J
    coupled_scalar_variable = V
  []
  [divJ]
    type = DualDivField
    variable = V
    coupled_vector_variable = J
  []
  [forcing]
    type = BodyForce
    variable = V
    function = ${Functions/f/div}
    value = -1
  []
  [null]
    type = NullKernel
    variable = V
  []
[]

[AuxKernels]
  [current_density]
    type = CurrentDensity
    variable = Jaux
    potential = V
    execute_on = timestep_end
  []
[]

[BCs]
  [left_right]
    type = FunctionNeumannBC
    variable = V
    function = ${k}*sin(${k}*y)
    boundary = 'left right'
  []
  [top_bottom]
    type = FunctionNeumannBC
    variable = V
    function = 0
    boundary = 'top bottom'
  []
[]

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names = electrical_conductivity
    prop_values = 1
  []
[]

[Postprocessors]
  [PP]
    type = ElementIntegralVariablePostprocessor
    variable = V
    execute_on = linear
  []
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
  [L2Error]
    type = ElementVectorL2Error
    variable = J
    function = f
  []
[]

[Executioner]
  type = Steady
  solve_type = Linear
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'none'      
[]

[Outputs]
  exodus = true
[]
