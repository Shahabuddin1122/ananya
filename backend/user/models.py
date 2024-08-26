from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.db import models


# Create your models here.
class UserManager(BaseUserManager):
    def create_user(self, email, name, phone, date_of_birth, district, project, password=None):
        if not email:
            raise ValueError('Users must have an email address')
        email = self.normalize_email(email)
        user = self.model(email=email, name=name, phone=phone, date_of_birth=date_of_birth, district=district,
                          project=project)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, name, phone, date_of_birth, district, project, password=None):
        user = self.create_user(email, name, phone, date_of_birth, district, project, password)
        user.is_superuser = True
        user.is_staff = True
        user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    name = models.TextField()
    email = models.EmailField(unique=True)
    password = models.TextField()
    phone = models.TextField(unique=True)
    date_of_birth = models.DateField()
    district = models.TextField()
    project = models.TextField()

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name', 'phone', 'date_of_birth', 'district', 'project']


class SuperUser(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='managed_users')
    managed_users = models.ManyToManyField(User, related_name='superusers', blank=True)


class HealthCondition(models.Model):
    yeast_infection = models.BooleanField(default=False)
    urinary_track_infections = models.BooleanField(default=False)
    bacterial_vaginosis = models.BooleanField(default=False)
    polycystic_ovary_syndrome = models.BooleanField(default=False)
    endometriosis = models.BooleanField(default=False)
    fibroids = models.BooleanField(default=False)
    i_am_not_sure = models.BooleanField(default=False)
    no_health_issue = models.BooleanField(default=False)


class Questionnaire(models.Model):
    is_period_regular = models.BooleanField(default=False)
    days_between_period = models.IntegerField(default=28)
    length_of_period = models.IntegerField(default=5)
    last_period_start = models.DateField()
    take_birth_control = models.BooleanField(default=False)
    health_condition = models.ForeignKey(HealthCondition, on_delete=models.CASCADE, related_name='questionnaires')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user')


class PeriodHistory(models.Model):
    period_start = models.DateField()
    cycle_length = models.IntegerField()
    days_between_period = models.IntegerField(default=28)
    anomalies = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='period_history')


class PeriodPrediction(models.Model):
    period_start_from = models.DateField()
    period_start_to = models.DateField()
    length_of_period = models.IntegerField()
    days_between_period = models.IntegerField(default=28)
    anomalies = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='period_predictions')
