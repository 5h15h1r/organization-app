defmodule OrganizationApi.HandleError do

  def handle_repo_result({:ok, result}, _error_message), do: {:ok, result}
  def handle_repo_result({:error, %Ecto.Changeset{} = changeset}, _error_message), do: {:error, changeset}
  def handle_repo_result({:error, _reason}, error_message), do: {:error, error_message}
end
