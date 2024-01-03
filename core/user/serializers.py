from rest_framework import serializers
from django.conf import settings
from core.abstract.serializers import AbstractSerializer
from core.user.models import User

class UserSerializer(AbstractSerializer):
    name = serializers.SerializerMethodField()
    def get_name(self,instance):
        return instance.first_name+" "+instance.last_name
    class Meta:
       model = User
       fields = ['id', 'username','name', 'first_name',
           'last_name','email',
           'is_active', 'created', 'updated']
       read_only_field = ['is_active']