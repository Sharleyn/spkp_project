defmodule SpkpProjectWeb.EditProfileLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border p-8 max-w-2xl mx-auto">
      <h3 class="text-3xl font-semibold text-gray-800 text-center mb-8">Edit Profile</h3>

      <!-- Profile Picture -->
      <div class="flex flex-col items-center mb-8">
        <div class="w-32 h-32 bg-black rounded-full mb-4 flex items-center justify-center">
          <!-- Profile picture placeholder -->
        </div>
        <button class="text-xl font-semibold text-gray-800 hover:text-gray-600">
          Edit
        </button>
      </div>

      <.form
        for={@changeset}
        id="profile-form"
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
        class="space-y-6"
      >
        <div>
          <label class="block text-xl font-semibold text-gray-800 mb-2">Nama Penuh</label>
          <.input field={@changeset[:name]} type="text" placeholder="Masukkan nama penuh" />
        </div>

        <div>
          <label class="block text-xl font-semibold text-gray-800 mb-2">Emel</label>
          <.input field={@changeset[:email]} type="email" placeholder="Masukkan emel" />
        </div>

        <div>
          <label class="block text-xl font-semibold text-gray-800 mb-2">No Telefon</label>
          <.input field={@changeset[:phone]} type="tel" placeholder="Masukkan nombor telefon" />
        </div>

        <div>
          <label class="block text-xl font-semibold text-gray-800 mb-2">Password Baru</label>
          <.input field={@changeset[:password]} type="password" placeholder="Masukkan password baru" />
        </div>

        <div class="flex justify-center pt-4">
          <button type="submit"
                  class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-8 rounded-lg">
            Simpan
          </button>
        </div>
      </.form>
    </div>
    """
  end
end
