defmodule Atomix.Invocation.Circuit do
  alias Atomix.Invocation.Parser
  require Logger
  # Receives an expression and is the point of departure for rendering to electronic or software.

  # creates a function that, when given the specifics of the hardware or software propagation delays, computs
  # logical effort
  # From https://en.wikipedia.org/wiki/Logical_effort
  def logical_effort(expression) do
    0
  end

  def electrical_effort(expression) do
    0
  end

  def expression(expression_str) do
    {:ok, expression, _, _, _, _} = Parser.expression(expression_str)
    expression
  end

  def invocation_names(expression) do
    invocations =
      expression
      |> Keyword.get(:expression)
      |> Keyword.get_values(:invocation)

    [invocations] = invocations
    Keyword.get_values(invocations, :invocation_name)
  end

  def definition_names(expression) do
    definitions =
      expression
      |> Keyword.get(:expression)
      |> Keyword.get_values(:definition)

    [definitions] = definitions
    Keyword.get_values(definitions, :definition_name)
  end

  def check(expression) do
    # Ensure every invocation has a matching definition
    Logger.info("Check definitions: #{definition_names(expression)}")
    Logger.info("Check invocations: #{invocation_names(expression)}")
    invocation_names(expression) == definition_names(expression)
  end
end
