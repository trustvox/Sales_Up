class OverviewController < ApplicationController
  include OverviewPoints

  def search_overview_months
    init_overview_search_months

    start_overview_search
    overview_data('m')
    create_range_month_list
  end

  def search_overview_reports
    init_overview_search_reports

    start_overview_search
    @salesman_points = overview_data('r')
    create_range_month_list
  end

  private

  def create_range_month_list
    selection_list
    adjust_list(@last_list, @last_report)
  end

  def init_overview_search_reports
    @salesman_points = []
    @users = fetch_user_by_priority(1)
    @usernames = fetch_username_by_salesman_priority

    init_overview_search_bar
  end

  def init_overview_search_months
    @goal_points = []
    @sum_points = []
    @months_between = []

    init_overview_search_bar
  end

  def init_overview_search_bar
    @first_list = []
    @last_list = []

    @first_report = nil
    @last_report = nil
  end

  def start_overview_search
    return init_overview_data(nil, nil) if params[:report].nil?
    init_overview_data(params[:report][:month].split('/'),
                       params[:report][:year].split('/'))
  end

  def selection_list
    create_lists(@first_list)
    create_lists(@last_list)
    adjust_list(@first_list, @first_report)
  end

  def create_lists(date_list)
    all_date_list.map { |m| date_list << (m.month + '/' + m.year.to_s) }
  end

  def adjust_list(date_list, report)
    date_list.delete(report.month + '/' + report.year.to_s)
    date_list.unshift(report.month + '/' + report.year.to_s)
  end
end
