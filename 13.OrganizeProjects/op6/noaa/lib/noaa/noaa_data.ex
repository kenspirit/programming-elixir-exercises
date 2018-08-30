defmodule Noaa.NoaaData do
  require Logger

  @user_agent [ { "User-agent", "Elixir chengusky@gmail.com" } ]
  @noaa_url Application.get_env(:noaa, :noaa_url)
  @columns [
    { "observation_time", "Last Updated" },
    { "observation_time_rfc822", "" },
    { "weather", "Weather" },
    { "temperature_string", "Temperature" },
    { "dewpoint_string", "Dewpoint" },
    { "relative_humidity", "Relative Humdity" },
    { "wind_string", "Wind" },
    { "visibility_mi", "Visibility" },
    { "pressure_string", "MSL Pressure" },
    { "pressure_in", "Altimeter" },
  ]

  def data_columns, do: @columns

  def fetch_data(locations) do
    Logger.info fn -> "Fetching noaa data for locations #{inspect(locations)}" end

    Enum.reduce(locations, %{}, fn location, acc ->
      data = data_url(location)
      |> HTTPoison.get(@user_agent)
      |> handle_response()

      Map.put(acc, String.upcase(location), data)
    end)
  end

  defp data_url(location) do
    IO.puts "#{@noaa_url}#{location}.xml"
    "#{@noaa_url}#{location}.xml"
  end

  defp handle_response({ :ok, %{ status_code: status_code, body: body } }) do
    Logger.info("Got response: status code = #{status_code}")
    Logger.debug(fn -> inspect(body) end)

    parse_response(status_code, body)
  end

  defp parse_response(200, body) do
    body
    |> parse_body(Enum.map(@columns, fn { c, _ } -> c end))
  end

  defp parse_response(_, _), do: :error

  @doc """
  ## Sample data

  <?xml version="1.0" encoding="ISO-8859-1"?> 
  <?xml-stylesheet href="latest_ob.xsl" type="text/xsl"?>
  <current_observation version="1.0"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="http://www.weather.gov/view/current_observation.xsd">
    <credit>NOAA's National Weather Service</credit>
    <credit_URL>http://weather.gov/</credit_URL>
    <image>
      <url>http://weather.gov/images/xml_logo.gif</url>
      <title>NOAA's National Weather Service</title>
      <link>http://weather.gov</link>
    </image>
    <suggested_pickup>15 minutes after the hour</suggested_pickup>
    <suggested_pickup_period>60</suggested_pickup_period>
    <location>York, York Airport, PA</location>
    <station_id>KTHV</station_id>
    <latitude>39.9194</latitude>
    <longitude>-76.8769</longitude>
    <observation_time>Last Updated on Aug 22 2018, 9:53 pm EDT</observation_time>
    <observation_time_rfc822>Wed, 22 Aug 2018 21:53:00 -0400</observation_time_rfc822>
    <weather>Mostly Cloudy</weather>
    <temperature_string>70.0 F (21.1 C)</temperature_string>
    <temp_f>70.0</temp_f>
    <temp_c>21.1</temp_c>
    <relative_humidity>71</relative_humidity>
    <wind_string>from the Northwest at 11.5 gusting to 19.6 MPH (10 gusting to 17 KT)</wind_string>
    <wind_dir>Northwest</wind_dir>
    <wind_degrees>300</wind_degrees>
    <wind_mph>11.5</wind_mph>
    <wind_gust_mph>19.6</wind_gust_mph>
    <wind_kt>10</wind_kt>
    <wind_gust_kt>17</wind_gust_kt>
    <pressure_string>1012.3 mb</pressure_string>
    <pressure_mb>1012.3</pressure_mb>
    <pressure_in>29.90</pressure_in>
    <dewpoint_string>60.1 F (15.6 C)</dewpoint_string>
    <dewpoint_f>60.1</dewpoint_f>
    <dewpoint_c>15.6</dewpoint_c>
    <visibility_mi>10.00</visibility_mi>
    <icon_url_base>http://forecast.weather.gov/images/wtf/small/</icon_url_base>
    <two_day_history_url>http://www.weather.gov/data/obhistory/KTHV.html</two_day_history_url>
    <icon_url_name>nbkn.png</icon_url_name>
    <ob_url>http://www.weather.gov/data/METAR/KTHV.1.txt</ob_url>
    <disclaimer_url>http://weather.gov/disclaimer.html</disclaimer_url>
    <copyright_url>http://weather.gov/disclaimer.html</copyright_url>
    <privacy_policy_url>http://weather.gov/notice.html</privacy_policy_url>
  </current_observation>
  """
  def parse_body(body, field_names) do
    Enum.reduce(field_names, %{}, fn field_name, acc ->
      Map.merge(acc, extract_field(body, field_name))
    end)
  end

  def extract_field(body, field_name) do
    field_value = String.split(body, "<#{field_name}>")
    |> Enum.at(1)
    |> String.split("</#{field_name}>")
    |> Enum.at(0)

    Map.put(%{}, field_name, field_value)
  end
end
