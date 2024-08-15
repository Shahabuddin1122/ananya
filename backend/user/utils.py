from datetime import datetime, timedelta
from user.models import PeriodHistory


def get_period_date(question_info):
    last_period_start = datetime.strptime(question_info['last_period_start'], '%Y-%m-%d')
    days_between_period = question_info['days_between_period']
    period_history = PeriodHistory.objects.filter(user_id=question_info['user'])

    if not period_history.exists():
        return None

    total_period = sum([data.cycle_length for data in period_history])
    number = period_history.count()
    average_period_cycle = total_period / number

    if question_info.get('is_period_regular'):
        if not question_info.get('take_birth_control'):
            next_period_date_from = last_period_start + timedelta(days=days_between_period)
            next_period_date_to = last_period_start + timedelta(days=days_between_period)
        else:
            next_period_date_from = last_period_start + timedelta(days=average_period_cycle)
            next_period_date_to = last_period_start + timedelta(days=average_period_cycle)
    else:
        next_period_date_from = last_period_start + timedelta(days=average_period_cycle - 5)
        next_period_date_to = last_period_start + timedelta(days=average_period_cycle + 5)

        health_condition = question_info.get('health_condition', 'No health issues')
        if health_condition in ['Polycystic Ovary Syndrome']:
            next_period_date_from += timedelta(days=10)
            next_period_date_to += timedelta(days=10)
        elif health_condition in ['Endometriosis', 'Fibroids']:
            next_period_date_to += timedelta(days=5)

    return {
        "period_start_from": next_period_date_from.strftime('%Y-%m-%d'),
        "period_start_to": next_period_date_to.strftime('%Y-%m-%d'),
    }
