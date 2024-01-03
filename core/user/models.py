from django.db import models
from core.abstract.models import AbstractManager,AbstractModel
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class UserManager(AbstractManager,BaseUserManager):

    def create_user(self, username, email, password=None,**kwargs):
        """Create and return a `User` with an email, phone
                number, username and password."""
        if username is None:
                raise TypeError('Users must have a username.')
        if email is None:
                raise TypeError('Users must have an email.')
        if password is None:
                raise TypeError('User must have an email.')
        user = self.model(username=username,
                email=self.normalize_email(email), **kwargs) # normailze email lowercases the domain part
        user.set_password(password) # to make sure password is hashed that is 
                                    # why we didnot add it to user when creating it
        user.save(using=self._db) # if we have multiple databse connections
        return user
    
    def create_superuser(self, username, email, password,**kwargs):
        """
        Create and return a `User` with superuser (admin)
                permissions.
        """
        if password is None:
                raise TypeError('Superusers must have apassword.')
        if email is None:
                raise TypeError('Superusers must have an email.')
        if username is None:
           raise TypeError('Superusers must have an username.')
        user = self.create_user(username, email, password,**kwargs)
        user.is_superuser = True
        user.is_staff = True
        user.save(using=self._db)
        return user

class User(AbstractModel,AbstractBaseUser,PermissionsMixin):

    username = models.CharField(db_index=True,
       max_length=255, unique=True)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.EmailField(db_index=True, unique=True)
    is_active = models.BooleanField(default=True)
    is_superuser = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)

    USERNAME_FIELD = 'email' # user will be identified with their emails 
    # so they login with their emails
    REQUIRED_FIELDS = ['username']
    objects = UserManager()
    @property
    def name(self):
        return f"{self.first_name} {self.last_name}"