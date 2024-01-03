from rest_framework_nested import routers
from core.auth.viewsets.refresh import RefreshViewSet
from core.auth.viewsets.login import LoginViewSet
from core.auth.viewsets.register import RegisterViewSet
from core.user.viewsets import UserViewSet
from core.MLApp.viewsets import PredictViewSet
router = routers.SimpleRouter()

#user
router.register(r'user', UserViewSet, basename='user')
#register
router.register(r'auth/register', RegisterViewSet,basename='auth-register')
#login
router.register(r'auth/login', LoginViewSet,basename='auth-login')
#refresh
router.register(r'auth/refresh', RefreshViewSet,basename='auth-refresh')
#Prediction models
router.register(r'predict', PredictViewSet, basename='predict')

urlpatterns = [
   *router.urls,
]