defmodule SimpleCrawler do

  def main do
    url = user_input("URLを入力してください。\n")
    file_name = user_input("URLとテキスト情報を出力するファイルを拡張子付きで入力してください。\n")
    domain = get_domain(url)

    check_url([url], domain)
    |> get_page_text()
    |> file_write(file_name)
  end

  def get_url(url) do
    html = HTTPoison.get!(url)

    Floki.parse_document!(html.body)
    |> Floki.find("a")
    |> Floki.attribute("href")
  end

  def get_url_list(url_list,domain) do
    list = 
    for url <- url_list do
      get_url(url)
      |> Enum.filter(&String.starts_with?(&1, domain))
    end
    List.flatten(list)
  end

  def get_page_text(url_list) do
    for url <- url_list do
      html = HTTPoison.get!(url)

      text =
      Floki.parse_document!(html.body)
      |> Floki.find("body")
      |> Floki.text()
      |> String.replace([" ","\n"],"")

      "#{url}\n#{text}\n\n"
    end
  end

  def check_url(url_list,domain) do
    all_url = Enum.uniq(url_list ++ get_url_list(url_list,domain))

    if all_url == url_list do
      all_url
    else
      check_url(all_url,domain)
    end
  end

  def file_write(data, file_name) do
    File.open!(file_name, [:write])
    |> IO.binwrite(data)
  end

  def user_input(dis_play_value) do
    IO.gets(display_value)
    |> String.replace("\n","")
  end

  def get_domain(url) do
    [means_commuication, _, _domain|_]=String.split(url,"/")
    #{means_commuication}//#{domain}"
  end
end