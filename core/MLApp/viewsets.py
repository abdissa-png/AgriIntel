from rest_framework.viewsets import GenericViewSet
from rest_framework.response import Response
from rest_framework.decorators import action
from django.core.files.base import ContentFile
import base64
from PIL import Image
import cv2
import numpy as np
import tensorflow as tf
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from core.MLApp.serializers import CropPredictSerializer, ImageSerializer
from .apps import Disease_Detection_model,Plant_Disesase_Categories,Crop_Recommendation_Model,Crop_Damage_Classification_Model,Crop_Damage_Categories,Weed_Detection_Model
import numpy as np
import matplotlib.pyplot as plt
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

      # Add extra dimension to support batches
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
      prediction = Crop_Recommendation_Model.predict(test.reshape(1,-1))[0]
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

      #add extra dimension to support batches
      image = np.expand_dims(image, axis=0)

      # Now you can use the processed image for prediction
      predictions = Crop_Damage_Classification_Model.predict(image)

      return Response({"message": "Image received and processed.", 'prediction': dict(zip(list(Crop_Damage_Categories.keys()), predictions[0].tolist()))})
  @action(detail=False,methods=['post'],url_path='WeedDetection')
  def WeedDetection(self,request):
        serializer = ImageSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        # Get the image from the validated data
        image = serializer.validated_data['image']

        # Convert the image to a NumPy array
        image = Image.open(image)

        #   res = Weed_Detection_Model(image)
        #   detect_img = res[0].plot()
        #   detect_img = cv2.cvtColor(detect_img, cv2.COLOR_BGR2RGB)

        #   # Convert the image to a byte stream
        #   _, buffer = cv2.imencode('.jpg', detect_img)

        #   # Convert the byte stream to a base64 string
        #   img_str = base64.b64encode(buffer).decode('utf-8')
        results = Weed_Detection_Model.predict(image)
        boxes = results[0].boxes.xywh.cpu()                        #xywh bbox list
        clss = results[0].boxes.cls.cpu().tolist()                 #classes Id list
        names = results[0].names                                   #classes names list
        confs = results[0].boxes.conf.float().cpu().tolist()       #probabilities of classes
        output=[]
        for box, cls, conf in zip(boxes, clss, confs):
            x, y, w, h = box
            label = str(names[cls] + " {:.2f}".format(conf))
            x1, y1, x2, y2 = x-w/2, y-h/2, x+w/2, y+h/2
            output.append([x1,y1,x2,y2,label])   
        return Response({"message": "Image received and processed.", 'prediction': output})