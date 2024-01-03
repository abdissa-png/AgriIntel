from rest_framework import serializers

class CropPredictSerializer(serializers.Serializer):
    N = serializers.FloatField()
    P = serializers.FloatField()
    K = serializers.FloatField()
    temp = serializers.FloatField()
    humidity = serializers.FloatField()
    ph = serializers.FloatField()
    rainfall = serializers.FloatField()
class ImageSerializer(serializers.Serializer):
   image = serializers.FileField(required=True)
