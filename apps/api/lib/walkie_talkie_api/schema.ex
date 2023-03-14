defmodule WalkieTalkie.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      def get_schema do
        __MODULE__.__schema__(:fields) -- __MODULE__.__schema__(:embeds)
      end
    end
  end
end
