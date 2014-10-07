require_relative './sign_data_source'
require 'json'
require 'yaml'

class MorningStarDataSource < SignDataSource

  base_uri 'members.morningstar.ca:443'

  def initialize(options = {})
    options = {email: ENV['MORNINGSTAR_EMAIL'], password: ENV['MORNINGSTAR_PASSWORD']}.merge(options)

    @options = {
      'ctl00$MainContent$email_textbox' => options[:email],
      'ctl00$MainContent$pwd_textbox' => options[:password]
    }

    @cookie = load_cookie(options[:email])

    unless @cookie
      login_get = self.class.get('/login.aspx')
      view_state = /<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="(?<value>.*?)" \/>/
      event_validation = /<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="(?<value>.*?)" \/>/
      match_view_state = view_state.match(login_get)
      match_event_validation = event_validation.match(login_get)

      @options = @options.merge(
        {
          __LASTFOCUS: '',
          __EVENTTARGET: '',
          __EVENTARGUMENT: '',
          __VIEWSTATE: match_view_state['value'],
          __EVENTVALIDATION: match_event_validation['value'],
          'ctl00$MainContent$go_button.x' => '57',
          'ctl00$MainContent$go_button.y' => '9',
          'ctl00$MainContent$email_textbox2'=> ''
        })

      login_post = self.class.post(
          '/login.aspx',
          body: @options,
          headers: {'Cookie' => login_get.headers['Set-Cookie']}
      )
      @cookie = login_post.request.options[:headers]['Cookie']

      save_cookie(options[:email], @cookie)
    end
  end

  def get_data(options={})

    self.class.base_uri 'portfoliomgr.morningstar.ca'

    response = self.class.get('/RtPort/Reg/MyView.aspx', headers: {'Cookie' => @cookie})

    day_delta = /var allData = (?<data>.*?);\s+initData\(\)/
    match_day_delta = day_delta.match(response)
    match_day_delta = JSON.parse(match_day_delta['data'])

    ts = match_day_delta['TS']
    ts.gsub!(/'/,'"')
    ts = JSON.parse("{\"ts\":#{ts}}")['ts']

    data = {}
    columns = match_day_delta['H']['HS']
    columns.gsub!(/'/,'"')
    columns = JSON.parse("{\"columns\":#{columns}}")['columns']
    columns.each_with_index do |column, index|
      column = column[1]
      column.gsub!(/<br\/>/,' ')
      column.strip!
      data[column] = ts[index]
    end

    "#{data['$ Gain/Loss Since Purch']}=#{data['$ Day Change']}@#{data['$ Market Value']}"
  end

  private
  def load_cookie(name)
    file = File.open("#{self.class}_#{name}.cookies", 'rb')
    YAML.load(file.read)
  rescue
    nil
  end

  def save_cookie(name, cookie)
    File.open("#{self.class}_#{name}.cookies", 'w') do |file|
      file.write( YAML.dump(cookie))
    end
  end
end