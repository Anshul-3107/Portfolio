from django.urls import path
from .views import DandelionChatAPIView

urlpatterns = [
    path('chat/', DandelionChatAPIView.as_view(), name='dandelion-chat'),
]
