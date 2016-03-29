require_relative '../../lib/calendar'
class CalendarController < ApplicationController


  def execute
    begin
      Calendar::execute_task(params['task_label'], params['task_id'])

    rescue Exception => e
      @alert = "Calendar not start execution task #{params['task_label']} : #{e.message}"
    else
      @notice = "Calendar start execution task #{params['task_label']}"
    ensure
      @tasks = Calendar::current_date(params['current_date'], params['policy_id'], params['policy_type'])
      @policy_type =params['policy_type']
      @policy_id = params['policy_id']
      @current_date = params['current_date']
    end
  end
  def day
    begin
      @tasks = Calendar::current_date(params['current_date'], params['policy_id'], params['policy_type'])

    rescue Exception => e
      @alert = "cannot get day #{params['current_date']} task : #{e.message}"
    else
    ensure
      @policy_type =params['policy_type']
      @policy_id = params['policy_id']
      @current_date = Date.parse(params['current_date'])
    end

  end

  def prev_day
    begin
      @tasks = Calendar::prev_day(params['current_date'], params['policy_id'], params['policy_type'])

    rescue Exception => e
      @alert = "cannot get previous day task : #{e.message}"
    else
    ensure
      @policy_type =params['policy_type']
      @policy_id = params['policy_id']
      @current_date = Date.parse(params['current_date']).prev_day
    end
  end

  def today
    begin
      @tasks = Calendar::today(params['policy_id'], params['policy_type'])

    rescue Exception => e
      @alert = "cannot get today task : #{e.message}"
    else
    ensure
      @policy_type =params['policy_type']
      @policy_id = params['policy_id']
      @current_date = Date.today
    end
  end

  def next_day
    begin
      @tasks = Calendar::next_day(params['current_date'], params['policy_id'], params['policy_type'])

    rescue Exception => e
      @alert = "cannot get next day task : #{e.message}"
    else
    ensure
      @policy_type =params['policy_type']
      @policy_id = params['policy_id']
      @current_date = Date.parse(params['current_date']).next_day
    end
  end

  private


  def calendar_params
    params.require(:calendar).permit(:current_date,
                                     :policy_id,
                                     :policy_type,
                                     :task_id,
                                     :task_label)
  end

end

