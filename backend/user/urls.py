from django.urls import path
from . import views

urlpatterns = [
    path('signup', views.user_signup, name='user_signup'),
    path('superuser/signup', views.super_user_signup, name='super_user_signup'),
    path('login', views.user_login, name='user_login'),
    path('add-user', views.add_user_in_superuser, name='add-user-in-superuser'),
    path('get-user/<int:user_id>', views.get_user, name='get_user'),
]