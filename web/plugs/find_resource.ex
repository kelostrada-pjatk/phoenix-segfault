defmodule Segfault.Plugs.FindResource do
  import Plug.Conn

  def init(default), do: default

  @doc """
  Finds a resource with provided key which is dependant on another resource
  """
  def call(conn, %{:resource => resource_atom, :type => type, :key => key, :dependency => dependency_atom}) do
    assign_dependant_resource conn, resource_atom, type, key, dependency_atom
  end

  @doc """
  Finds a resource which is dependant on another resource
  """
  def call(conn, %{:resource => resource_atom, :type => type, :dependency => dependency_atom}) do
    assign_dependant_resource conn, resource_atom, type, "id", dependency_atom
  end

  defp assign_dependant_resource conn, resource_atom, type, key, dependency_atom do
    dependency_key = Atom.to_string(dependency_atom) <> "_id"
    dependency_key_atom = String.to_atom(dependency_key)
    resource = Segfault.Repo.get_by!(type, %{:id => conn.params[key], dependency_key_atom => conn.params[dependency_key]})
    assign(conn, resource_atom, resource)
  end

  @doc """
  Finds a resource with provided params key
  """
  def call(conn, %{:resource => resource_atom, :type => type, :key => key})  do
    assign_resource conn, resource_atom, type, key
  end

  @doc """
  Finds a resource with default params key "id"
  """
  def call(conn, %{:resource => resource_atom, :type => type})  do
    assign_resource conn, resource_atom, type, "id"
  end

  defp assign_resource(conn, resource_atom, type, key) do
    resource = Segfault.Repo.get_by!(type, %{id: conn.params[key]})
    assign(conn, resource_atom, resource)
  end

end