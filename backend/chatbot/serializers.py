from rest_framework import serializers

class ChatMessageSerializer(serializers.Serializer):
    sender = serializers.ChoiceField(choices=['user', 'dandelion'])
    text = serializers.CharField(max_length=4000)

class ChatRequestSerializer(serializers.Serializer):
    message = serializers.CharField(required=True, max_length=1500)
    history = ChatMessageSerializer(many=True, required=False, default=[])

class ChatResponseSerializer(serializers.Serializer):
    reply = serializers.CharField()
    sender = serializers.CharField(default='dandelion')
    status = serializers.CharField(default='success')
