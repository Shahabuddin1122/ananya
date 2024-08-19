from datetime import datetime, timedelta
from user.models import PeriodHistory, Questionnaire


def get_period_date(user_id, last_period_start):
    period_history = PeriodHistory.objects.filter(user_id=user_id).order_by('-period_start')
    question_info = Questionnaire.objects.get(user_id=user_id)
    if not period_history.exists():
        return None

    most_recent_period = period_history.first()
    days_between_period = most_recent_period.days_between_period

    total_period = sum([data.days_between_period for data in period_history])
    total_period_length = sum([data.cycle_length for data in period_history])
    number = period_history.count()
    average_period_cycle = int(total_period / number)
    average_period_length = int(total_period_length / number)

    if question_info.is_period_regular:
        if not question_info.take_birth_control:
            next_period_date_from = last_period_start + timedelta(days=days_between_period)
            next_period_date_to = last_period_start + timedelta(days=days_between_period)
            length_of_period = question_info.length_of_period
        else:
            next_period_date_from = last_period_start + timedelta(days=average_period_cycle)
            next_period_date_to = last_period_start + timedelta(days=average_period_cycle)
            length_of_period = average_period_length
    else:
        next_period_date_from = last_period_start + timedelta(days=average_period_cycle - 5)
        next_period_date_to = last_period_start + timedelta(days=average_period_cycle + 5)
        length_of_period = 15
        health_condition = question_info.health_condition
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
        "days_between_period": days_between_period if question_info.take_birth_control else average_period_cycle,
        "anomalies": 'Regular' if 21 <= average_period_cycle <= 30 else 'Irregular',
        "length_of_period": length_of_period,
    }
