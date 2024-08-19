from datetime import datetime, timedelta
from user.models import PeriodHistory


def get_period_date(question_info):
    period_history = PeriodHistory.objects.filter(user_id=question_info['user']).order_by('-period_start')

    if not period_history.exists():
        return None

    most_recent_period = period_history.first()
    last_period_start = most_recent_period.period_start
    days_between_period = most_recent_period.days_between_period

    total_period = sum([data.days_between_period for data in period_history])
    total_period_length = sum([data.cycle_length for data in period_history])
    number = period_history.count()
    average_period_cycle = total_period / number
    average_period_length = total_period_length / number

    if question_info.get('is_period_regular'):
        if not question_info.get('take_birth_control'):
            next_period_date_from = last_period_start + timedelta(days=days_between_period)
            next_period_date_to = last_period_start + timedelta(days=days_between_period)
            length_of_period = question_info.get('length_of_period')
        else:
            next_period_date_from = last_period_start + timedelta(days=average_period_cycle)
            next_period_date_to = last_period_start + timedelta(days=average_period_cycle)
            length_of_period = average_period_length
    else:
        next_period_date_from = last_period_start + timedelta(days=average_period_cycle - 5)
        next_period_date_to = last_period_start + timedelta(days=average_period_cycle + 5)
        length_of_period = 15
        health_condition = question_info.get('health_condition', 'No health issues')
        if health_condition == 'Polycystic Ovary Syndrome':
            next_period_date_from += timedelta(days=10)
            next_period_date_to += timedelta(days=10)
            length_of_period = length_of_period + 5
        elif health_condition in ['Endometriosis', 'Fibroids']:
            next_period_date_to += timedelta(days=5)
            length_of_period = length_of_period - 5
        else:
            length_of_period = average_period_length

    return {
        "period_start_from": next_period_date_from,
        "period_start_to": next_period_date_to,
        "days_between_period": days_between_period if question_info.get('take_birth_control') else average_period_cycle,
        "anomalies": 'Regular' if 21 <= average_period_cycle <= 30 else 'Irregular',
        "length_of_period": length_of_period,
    }
