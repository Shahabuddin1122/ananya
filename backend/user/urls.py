from django.urls import path
from . import views

urlpatterns = [
    path('signup', views.user_signup, name='user_signup'),
    path('superuser/signup', views.super_user_signup, name='super_user_signup'),
    path('login', views.user_login, name='user_login'),
    path('add-user/<int:superuser_id>', views.add_user_in_superuser, name='add-user-in-superuser'),
    path('get-cohort/<int:superuser_id>', views.get_cohorts, name='get_all_cohorts'),
    path('get-user/<int:user_id>', views.get_user, name='get_user'),
    path('add-period-info/<int:user_id>', views.add_period_info, name='add_period_info'),
    path('get-user-period-questionnaire/<int:user_id>', views.get_user_period_questionnaire,
         name='get_user_period_questionnaire'),
    path('get-prediction-period/<int:user_id>', views.get_period_prediction, name='get_period_date'),
    path('log-new-period/<int:user_id>', views.log_new_period, name='log_new_period'),
    path('get-period-history/<int:user_id>', views.get_period_history, name='get_period_history'),
    path('confim-period/<int:user_id>', views.period_confirmation, name='period_confirmation'),
    path('update-period-information/<int:user_id>', views.update_period_information, name='update_period_information'),
    path('advance-period-information/<int:user_id>', views.advance_period_information, name='advance_period_information'),
    path('get-cohort-user/<int:superuser_id>', views.get_cohort_user, name='get_cohort_user'),
]
