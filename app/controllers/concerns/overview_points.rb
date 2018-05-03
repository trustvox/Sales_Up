module OverviewPoints
  include DatabaseSearchs

  def init_overview_data(first, last)
    first.blank? ? fetch_reports : fetch_reports(first, last)

    session[:goal_points] = '[ '
    session[:sum_points] = '[ '
    session[:months_between] = [session[:first_report]]
    session[:first_list] = []
    session[:last_list] = []
  end

  def fetch_reports(first = nil, last = nil)
    if all_nil?(first, last)
      session[:last_report] = fetch_last_report
      session[:first_report] =
        fetch_reports_by_month_range(session[:last_report], 6)
    else
      search_first_last_reports(first, last)
      verify_dates
    end
  end

  def search_first_last_reports(first, last)
    session[:last_report] = fetch_report(last[0], last[1])
    session[:first_report] = fetch_report(first[0], first[1])
  end

  def all_nil?(first, last)
    first.blank? || last.blank?
  end

  def verify_month
    session[:first_report].month_numb > session[:last_report].month_numb
  end

  def verify_year
    session[:first_report].year >= session[:last_report].year
  end

  def switch
    session[:first_report], session[:last_report] =
      session[:last_report], session[:first_report]
  end

  def verify_dates
    switch if (!verify_month && verify_year) || verify_year
  end

  def acceptable?(first)
    !first.nil? &&
      (first.month_numb != session[:last_report].month_numb + 1 ||
      first.year != session[:last_report].year)
  end

  def overview_data
    @i = 1
    first = session[:first_report]

    while acceptable?(first)
      store_data(@i.to_s, first.goal.to_s, first.id)
      first = verify_next_month(first)
    end

    session[:goal_points][-1] = ']'
    session[:sum_points][-1] = ']'
  end

  def store_data(index, goal, id)
    session[:goal_points] += '[' + index + ', ' + goal + '], '
    session[:sum_points] += '[' + index + ', ' + fetch_sum(id) + '], '
  end

  def verify_next_month(first)
    @i += 1
    report = fetch_report_by_next_month(first)
    session[:months_between] << report unless report.nil?
    report
  end

  def fetch_sum(id)
    sum = 0
    fetch_contract_by_report_id(id).each do |contract|
      sum += contract.value
    end
    sum.to_s
  end
end
