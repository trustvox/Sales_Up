module DatabaseSearchs
  include ReportSearchs
  include ContractSearchs
  include UserSearchs

  def month_days
    Time.days_in_month(@current_report.month_numb)
  end

  def all_date_list
    list = []
    fetch_all_years.each do |year|
      fetch_reports_by_year(year).each do |report|
        list << report
      end
    end
    list
  end

  def fetch_default_data
    Date::MONTHNAMES[fetch_last_month] + '/' + fetch_last_year.to_s
  end
end
