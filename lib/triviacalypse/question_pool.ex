defmodule Triviacalypse.QuestionPool do
  use GenServer

  alias Triviacalypse.{Question, QuestionPool}

  @type question :: Question.t()

  @type t :: %QuestionPool{
          questions: [question]
        }

  defstruct questions: []

  @name QuestionPool
  @default_opts [name: @name]
  @api Application.get_env(:triviacalypse, Triviacalypse.GameServer)[:api]
  @retry_time 3_000
  @water_count 10

  @spec start_link(keyword) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    opts = Keyword.merge(@default_opts, opts)
    GenServer.start_link(QuestionPool, %QuestionPool{}, opts)
  end

  @impl true
  @spec init(t) :: {:ok, t}
  def init(state) do
    Process.send_after(self(), :request, 0)

    {:ok, state}
  end

  @spec get :: {:ok, question} | {:error, any}
  def get do
    GenServer.call(@name, :get)
  end

  @impl true
  def handle_call(:get, _from, state) do
    case state.questions do
      [question | questions] ->
        if length(questions) < @water_count do
          Process.send_after(self(), :request, 0)
        end

        {:reply, {:ok, question}, %QuestionPool{state | questions: questions}}

      [] ->
        Process.send_after(self(), :request, 0)
        {:reply, {:error, :not_working}, state}
    end
  end

  @impl true
  def handle_info(:request, state) do
    case @api.get() do
      {:ok, questions} ->
        {:noreply, %QuestionPool{state | questions: state.questions ++ questions}}

      {:error, _error} ->
        Process.send_after(self(), :request, @retry_time)
        {:noreply, state}
    end
  end
end
