from django.urls import path
from .views import DandelionChatAPIView, LeetCodeStatsAPIView

urlpatterns = [
    path('chat/', DandelionChatAPIView.as_view(), name='dandelion-chat'),
    path('leetcode/', LeetCodeStatsAPIView.as_view(), name='leetcode-stats'),
]
