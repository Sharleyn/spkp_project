defmodule SpkpProjectWeb.SijilLive.Form do
  use SpkpProjectWeb, :live_view

  on_mount {SpkpProjectWeb.UserAuth, :mount_current_user}
  on_mount {SpkpProjectWeb.UserAuth, {:ensure_role, "admin"}}

  alias SpkpProject.{Certificate}
  alias SpkpProject.{Repo, Kursus}
  alias SpkpProject.Userpermohonan.Userpermohonan

  @impl true
  def mount(_params, _session, socket) do
         {:ok,
      socket
      |> assign(:page_title, "Muat Naik Sijil Kursus")
      |> assign(:sijil, %Certificate{})
      |> assign(:courses, Kursus.list_all_courses())
      |> assign(:form, to_form(Certificate.changeset(%Certificate{}, %{})))
                  |> allow_upload(:sijil_file,
          accept: ~w(.pdf application/pdf),
          max_entries: 1,
          max_file_size: 25_000_000
        )}
   end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    sijil = Repo.get!(Certificate, id)

    changeset =
      Certificate.changeset(sijil, %{
        nama_sijil: sijil.nama_sijil,
        issued_at: sijil.issued_at,
        user_id: sijil.user_id,
        kursus_id: sijil.kursus_id,
        sijil_url: sijil.sijil_url
      })

    {:noreply,
     socket
     |> assign(:page_title, "Kemaskini Sijil Kursus")
     |> assign(:sijil, sijil)
     |> assign(:form, to_form(changeset))}
  end

  def handle_params(%{"user_permohonan_id" => id}, _uri, socket) do
    user_permohonan =
      Repo.get!(Userpermohonan, String.to_integer(id))
      |> Repo.preload(:user)

    {:noreply,
     socket
     |> assign(:user_permohonan, user_permohonan)
     |> assign(:user_permohonan_id, user_permohonan.id)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        current_view={@socket.view}
        role={@current_user.role}
        current_user={@current_user}
        current_path={@socket.host_uri && @socket.host_uri.path}
      />

      <div class="flex-1 flex flex-col">
        <!-- Header -->
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              <h1 class="text-xl font-semibold text-gray-800">{@page_title}</h1>
            </div>
          </div>
        </.header>

        <!-- Main Content -->
        <div class="p-6 max-w-4xl w-full mx-auto">
          <div class="bg-white shadow-md rounded-lg p-6">
            <.simple_form
              for={@form}
              id="sijil-form"
              phx-change="validate"
              phx-submit="save"
            >
              <div class="space-y-4">

                <label class="block text-sm font-medium text-gray-700">
                  Fail Sijil (PDF sahaja)
                </label>

                <!-- Papar ralat muat naik umum -->
                <%= for err <- upload_errors(@uploads.sijil_file) do %>
                  <div class="text-sm text-red-600">
                    Ralat muat naik: <%= Phoenix.Naming.humanize(to_string(err)) %>
                  </div>
                <% end %>

                <!-- Papar progres muat naik untuk setiap entry -->
                <%= for entry <- @uploads.sijil_file.entries do %>
                  <div class="text-sm text-gray-600 flex justify-between items-center">
                    <span><%= entry.client_name %> - <%= entry.progress %>%</span>
                    <%= for err <- upload_errors(@uploads.sijil_file, entry) do %>
                      <span class="text-red-600 ml-2">
                        (ralat: <%= Phoenix.Naming.humanize(to_string(err)) %>)
                      </span>
                    <% end %>
                  </div>
                <% end %>

                <!-- Input fail -->
                <.live_file_input upload={@uploads.sijil_file} class="mt-2" />

                <!-- Papar fail sedia ada jika ada -->
                <%= if @sijil && @sijil.sijil_url do %>
                  <div class="text-sm text-gray-600 mt-2">
                    Sedia ada:
                    <a href={@sijil.sijil_url} class="text-blue-600 underline" target="_blank">
                      Lihat
                    </a>
                  </div>
                <% end %>
              </div>

              <:actions>
                <.button type="submit" class="bg-green-600 text-white mt-4 w-full">
                  Simpan
                </.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("validate", _params, socket) do
    # Only file upload; nothing to validate besides upload entries
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    upload_params = save_upload(socket, %{})

    case socket.assigns.live_action do
      :edit -> update_sijil(socket, socket.assigns.sijil, upload_params)
      _ -> create_sijil(socket, upload_params)
    end
  end

  defp create_sijil(socket, params) do
    case socket.assigns[:user_permohonan] do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "Ralat: Tiada user_permohonan diberikan.")
         |> assign(:form, to_form(Certificate.changeset(%Certificate{}, params)))}

      user_permohonan ->
        attrs =
          params
          |> Map.put("user_permohonan_id", user_permohonan.id)
          |> Map.put("user_id", user_permohonan.user_id)
          |> Map.put("kursus_id", user_permohonan.kursus_id)
          |> Map.put_new("issued_at", Date.utc_today())
          |> Map.put_new("nama_sijil", "Sijil Kursus")

        case SpkpProject.Sijil.create_sijil(attrs) do
          {:ok, _cert} ->
            {:noreply,
             socket
             |> put_flash(:info, "Sijil dimuat naik.")
             |> push_navigate(to: ~p"/admin/sijil/new")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :form, to_form(changeset))}
        end
    end
  end

  defp update_sijil(socket, sijil, params) do
    attrs =
      case params do
        %{"sijil_url" => sijil_url} when is_binary(sijil_url) -> %{sijil_url: sijil_url}
        _ -> %{}
      end

    changeset = Certificate.changeset(sijil, attrs)

    case Repo.update(changeset) do
      {:ok, sijil} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sijil berjaya dikemaskini")
         |> push_navigate(to: ~p"/admin/sijil/new")
         |> assign(:sijil, sijil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_upload(socket, params) do
    sijil_url =
      consume_uploaded_entries(socket, :sijil_file, fn %{path: path}, entry ->
        uploads_dir = Path.expand("./uploads")
        File.mkdir_p!(uploads_dir)

        ext = Path.extname(entry.client_name)
        unique_name = "#{System.unique_integer([:positive])}#{ext}"
        dest = Path.join(uploads_dir, unique_name)

        File.cp!(path, dest)
        {:ok, "/uploads/#{unique_name}"}
      end)
      |> List.first()

    if is_nil(sijil_url) do
      params
    else
      params
      |> maybe_put("sijil_url", sijil_url, socket.assigns.sijil && socket.assigns.sijil.sijil_url)
    end
  end

  defp maybe_put(params, key, new_val, old_val) do
    cond do
      is_binary(new_val) -> Map.put(params, key, new_val)
      is_binary(old_val) -> Map.put(params, key, old_val)
      true -> params
    end
  end
end
