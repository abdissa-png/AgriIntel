from django.contrib import admin
from core.user.models import User
# Register your models here.
@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['first_name', 'last_name', 'username', 'email', 'public_id']
    search_fields = ['username', 'email']
    date_hierarchy = 'created'
    ordering = ['updated', 'created']