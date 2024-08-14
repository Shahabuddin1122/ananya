from django.db import models


# Create your models here.
class User(models.Model):
    name = models.TextField()
    email = models.TextField(unique=True)
    password = models.TextField()
    phone = models.TextField(unique=True)
    date_of_birth = models.DateField()
    district = models.TextField()
    project = models.TextField()
    is_superuser = models.BooleanField(default=False)


class SuperUser(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='managed_users')
    managed_users = models.ManyToManyField(User, related_name='superusers', blank=True)

