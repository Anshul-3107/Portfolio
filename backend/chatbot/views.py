from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import ChatRequestSerializer, ChatResponseSerializer
from .services import GeminiDandelionService

class DandelionChatAPIView(APIView):
    """
    POST /api/chat/
    Payload:
    {
        "message": "Tell me about FraudLens",
        "history": [
            {"sender": "user", "text": "Hello"},
            {"sender": "dandelion", "text": "Greetings traveler!"}
        ]
    }
    """
    def post(self, request, *args, **kwargs):
        serializer = ChatRequestSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(
                {"error": serializer.errors, "status": "error"},
                status=status.HTTP_400_BAD_REQUEST
            )

        user_message = serializer.validated_data.get('message')
        history = serializer.validated_data.get('history', [])

        reply = GeminiDandelionService.generate_reply(user_message, history)

        response_data = {
            "reply": reply,
            "sender": "dandelion",
            "status": "success"
        }
        return Response(response_data, status=status.HTTP_200_OK)
