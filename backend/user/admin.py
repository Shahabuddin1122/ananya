from django.contrib import admin

from user.models import *

# Register your models here.
admin.site.register(User)
admin.site.register(SuperUser)
admin.site.register(Questionnaire)
admin.site.register(HealthCondition)