from django.contrib import admin
from .models import LoginUser

@admin.register(LoginUser)
class LoginUserAdmin(admin.ModelAdmin):
    list_display = ('username', 'password')
    search_fields = ('username',)
