module OverviewPoints
  include DatabaseSearchs

  DEFAULT_MONTH_SEARCH = 12

  def initialize
    @goal_points = []
    @sum_points = []
    @salesman_points = []
    @months_between = []

    @first_list = []
    @last_list = []

    @first_report = nil
    @last_report = nil
  end

  def init_overview_data(first, last)
    first.blank? ? fetch_reports : fetch_reports(first, last)
    @months_between = [@first_report]
  end

  def fetch_reports(first = nil, last = nil)
    if first.blank? || last.blank?
      @last_report = fetch_last_report
      @first_report =
        fetch_reports_by_month_range(@last_report, DEFAULT_MONTH_SEARCH)
    else
      search_first_last_reports(first, last)
      verify_dates
    end
  end

  def search_first_last_reports(first, last)
    @last_report = fetch_report(last[0], last[1])
    @first_report = fetch_report(first[0], first[1])
  end

  def greater_month
    @first_report.month_numb < @last_report.month_numb
  end

  def greater_year
    @first_report.year > @last_report.year
  end

  def same_year
    @first_report.year == @last_report.year
  end

  def switch
    @first_report, @last_report = @last_report, @first_report
  end

  def verify_dates
    switch if (same_year && !greater_month) || greater_year
  end

  def acceptable?
    !@first.nil? &&
      (@first.month_numb != @last_report.month_numb + 1 ||
      @first.year != @last_report.year)
  end

  def prepare_overview_data
    @i = 1
    @first = @first_report
  end

  def overview_data(which)
    prepare_overview_data
    which == 'm' ? overview_month_data : overview_report_data
  end

  def overview_month_data
    while acceptable?
      @goal_points << [@i, @first.goal]
      @sum_points << [@i, fetch_sum(@first.id)]
      verify_next_month
    end
  end

  def verify_next_month
    @i += 1
    report = fetch_report_by_next_month(@first)
    @months_between << report unless report.nil?
    @first = report
  end

  def fetch_sum(id)
    sum = 0
    fetch_contract_by_report_id(id).each do |contract|
      sum += contract.value
    end
    sum.to_s
  end

  def overview_report_data
    @users.collect do |user|
      list = []
      while acceptable?
        list << filter_operation(@i, user.id, @first.id)
        verify_next_month
      end

      prepare_overview_data
      list
    end
  end

  def filter_operation(index, user_id, report_id)
    case @filter
    when 'CS'
      [index, fetch_contract_sum(user_id, report_id)]
    when 'CP'
      sum = fetch_contract_sum(user_id, report_id)
      [index, ((sum / fetch_goal_by_id(report_id)) * 100).round(1)]
    when 'CC'
      [index, fetch_contracts_by_user_report_id(user_id, report_id)]
    end
  end
end