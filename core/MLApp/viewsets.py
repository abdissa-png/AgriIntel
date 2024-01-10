from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action
from django.core.files.base import ContentFile
import io
import os
from PIL import Image
import cv2
import numpy as np
import tensorflow as tf
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from core.MLApp.serializers import CropPredictSerializer, ImageSerializer
from .apps import Disease_Detection_model,Plant_Disesase_Categories,crop_recommendation,Crop_Damage_Classification_Model,Crop_Damage_Categories
import numpy as np

class PredictViewSet(GenericViewSet):
  permission_classes = [IsAuthenticated]
  @action(detail=False, methods=['post'], url_path='CropDisease')
  def DiseasePredict(self, request):
      serializer = ImageSerializer(data=request.data)
      if not serializer.is_valid():
          return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

      # Get the image from the validated data
      image = serializer.validated_data['image']

      # Convert the image to a NumPy array
      image_pil = Image.open(image)
      # Resize the image
      image_pil = image_pil.resize((128, 128))

      # Convert the PIL image to a NumPy array
      image = np.array(image_pil)
      image = np.expand_dims(image, axis=0)
      # Now you can use the processed image for prediction
      predictions = Disease_Detection_model.predict(image*(1./255))
      return Response({"message": "Image received and processed.", 'prediction': dict(zip(list(Plant_Disesase_Categories.keys()), predictions[0].tolist()))})
  @action(detail=False, methods=['post'], url_path='Crop')
  def CropPredict(self, request):
      serializer = CropPredictSerializer(data=request.data)
      if not serializer.is_valid():
          return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

      body = serializer.validated_data
      test = np.array([body['N'], body['P'], body['K'], body['temp'], body['humidity'], body['ph'], body['rainfall']])
      prediction = crop_recommendation.predict(test.reshape(1,-1))[0]
      return Response({'message':'Request received and processed.','prediction':f'The app recommends you to plant {prediction}'})
  @action(detail=False,methods=['post'],url_path='CropDamage')
  def CropDamagePredict(self,request):
      serializer = ImageSerializer(data=request.data)
      if not serializer.is_valid():
          return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

      # Get the image from the validated data
      image = serializer.validated_data['image']

      # Convert the image to a NumPy array
      image_pil = Image.open(image)

      # Convert the PIL image to a NumPy array
      image = np.array(image_pil)
      image=tf.keras.applications.mobilenet.preprocess_input(image)
      # Resize the image
      image = cv2.resize(image,(256,256))
      print(image.shape)
      image = np.expand_dims(image, axis=0)
      # Now you can use the processed image for prediction
      predictions = Crop_Damage_Classification_Model.predict(image)
      return Response({"message": "Image received and processed.", 'prediction': dict(zip(list(Crop_Damage_Categories.keys()), predictions[0].tolist()))})