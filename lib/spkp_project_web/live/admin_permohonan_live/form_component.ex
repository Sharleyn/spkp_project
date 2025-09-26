defmodule SpkpProjectWeb.PermohonanLive.FormComponent do
  use SpkpProjectWeb, :live_component
  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.{Repo, Mailer, Email}

  @impl true
  def update(%{permohonan: permohonan} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Userpermohonan.changeset(permohonan, %{}))
     end)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Gunakan borang ini untuk kemaskini maklumat permohonan.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="permohonan-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:status]}
          type="select"
          label="Status Permohonan"
          prompt="-- Pilih status --"
          options={[
            {"Dalam Proses", "Dalam Proses"},
            {"Diterima", "Diterima"},
            {"Ditolak", "Ditolak"}
          ]}
        />

        <:actions>
          <.button phx-disable-with="Menyimpan...">Simpan</.button>

          <.link
            patch={@patch || ~p"/admin/permohonan"}
            class="ml-2 inline-flex items-center px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
          >
            Kembali
          </.link>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"userpermohonan" => params}, socket) do
    changeset = Userpermohonan.changeset(socket.assigns.permohonan, params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"userpermohonan" => params}, socket) do
    save_permohonan(socket, socket.assigns.action, params)
  end

  defp save_permohonan(socket, :edit, params) do
    case Repo.update(Userpermohonan.changeset(socket.assigns.permohonan, params)) do
      {:ok, permohonan} ->
        # ✅ Hantar email ikut status
        send_status_email(permohonan)

        notify_parent({:saved, permohonan})

        {:noreply,
         socket
         |> put_flash(:info, "Permohonan berjaya dikemaskini & email dihantar")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # ⬇️ Fungsi ini hanya urus email, tidak guna socket/params
  defp send_status_email(%Userpermohonan{status: "Diterima"} = permohonan) do
    permohonan
    |> Repo.preload([:user, :kursus])
    |> Email.permohonan_diterima()
    |> Mailer.deliver()
  end

  defp send_status_email(%Userpermohonan{status: "Ditolak"} = permohonan) do
    permohonan
    |> Repo.preload([:user, :kursus])
    |> Email.permohonan_ditolak()
    |> Mailer.deliver()
  end

  defp send_status_email(_), do: :ok

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
