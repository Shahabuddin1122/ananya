from django.urls import path
from . import views

urlpatterns = [
    path('signup', views.user_signup, name='user_signup'),
    path('superuser/signup', views.super_user_signup, name='super_user_signup'),
    path('login', views.user_login, name='user_login'),
    path('add-user', views.add_user_in_superuser, name='add-user-in-superuser'),
    path('get-user/<int:user_id>', views.get_user, name='get_user'),
    path('add-period-info/<int:user_id>', views.add_period_info, name='add_period_info'),
    path('get-user-period-questionnaire/<int:user_id>', views.get_user_period_questionnaire,
         name='get_user_period_questionnaire'),
    path('get-prediction-period/<int:user_id>', views.get_period_prediction, name='get_period_date'),
    path('get-period-history/<int:user_id>', views.get_period_history, name='get_period_history'),
]
