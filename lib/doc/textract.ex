defmodule Atomix.Textract do
  use GenServer
  require Finch

  @endpoint "https://textract.us-east-2.amazonaws.com"

  def init(arg) do
    {:ok, arg}
  end

  def handle_call({:analyze, table_image}, _from, state) do
    IO.puts("Analyzing..")
    doc_base64 = Base.encode64(table_image)
    IO.inspect(doc_base64)
    headers = [{"User", "aws+user"}, {"Password", "aws-pass"}]
    body = %{Document: doc_base64}

    {:ok, finch_pid} = Finch.start_link(name: FinchTextract)
    IO.puts("Posting request")
    finch_request = Finch.build(:post, @endpoint, headers, body)
    IO.puts("Request:")
    IO.inspect(finch_request)
    finch_response = Finch.request(finch_request, FinchTextract)
    IO.inspect(finch_response)
    {:reply, "HAHA", state}
  end

  def analyze_document(path) do
    blob = "a"

    query = %{
      Document: %{
        Bytes: blob,
        S3Object: %{
          Bucket: "string",
          Name: "string",
          Version: "string"
        }
      },
      FeatureTypes: ["string"],
      HumanLoopConfig: %{
        DataAttributes: %{
          ContentClassifiers: ["string"]
        },
        FlowDefinitionArn: "string",
        HumanLoopName: "string"
      },
      QueriesConfig: %{
        Queries: [
          %{
            Alias: "string",
            Pages: ["string"],
            Text: "string"
          }
        ]
      }
    }
  end
end
