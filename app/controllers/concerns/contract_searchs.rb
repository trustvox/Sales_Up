module ContractSearchs
  def fetch_contract_by_report_id(report_id)
    Contract.where(report_id: report_id).order('day')
  end

  def destroy_contract_by_id(contract_id)
    Contract.find_by(id: contract_id).destroy
  end

  def fetch_contracts_by_day_report_user_id(day, report_id, user_id)
    Contract.where(day: day, report_id: report_id, user_id: user_id)
  end

  def fetch_contracts_by_day_report_id(day, report_id)
    Contract.where(day: day, report_id: report_id)
  end

  def fetch_contracts_by_user_report_id(user_id, report_id)
    Contract.where(user_id: user_id, report_id: report_id).order('day')
  end

  def fetch_contract_sum(user_id, report_id)
    values = 0
    contracts = fetch_contracts_by_user_report_id(user_id, report_id)
    contracts.each { |contract| values += contract.value }
    values
  end
end
