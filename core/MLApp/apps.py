from ultralytics import YOLO
import os
from django.apps import AppConfig
import tensorflow as tf
from keras.layers import Input , Dense , Flatten , GlobalAveragePooling2D
from keras import Sequential, Model
from keras.activations import softmax
import joblib

# 10 species (Apple,Coffee,Grape,Lemon,Mango,Potato,Rice,Sugarcane,Tea,Wheat) and 40 categories
Plant_Disesase_Categories={
 'Apple__black_rot': 0,
 'Apple__healthy': 1,
 'Apple__rust': 2,
 'Apple__scab': 3,
 'Coffee__cercospora_leaf_spot': 4,
 'Coffee__healthy': 5,
 'Coffee__red_spider_mite': 6,
 'Coffee__rust': 7,
 'Grape__black_measles': 8,
 'Grape__black_rot': 9,
 'Grape__healthy': 10,
 'Grape__leaf_blight_(isariopsis_leaf_spot)': 11,
 'Lemon__diseased': 12,
 'Lemon__healthy': 13,
 'Mango__diseased': 14,
 'Mango__healthy': 15,
 'Potato__early_blight': 16,
 'Potato__healthy': 17,
 'Potato__late_blight': 18,
 'Rice__brown_spot': 19,
 'Rice__healthy': 20,
 'Rice__hispa': 21,
 'Rice__leaf_blast': 22,
 'Rice__neck_blast': 23,
 'Sugarcane__bacterial_blight': 24,
 'Sugarcane__healthy': 25,
 'Sugarcane__red_rot': 26,
 'Sugarcane__red_stripe': 27,
 'Sugarcane__rust': 28,
 'Tea__algal_leaf': 29,
 'Tea__anthracnose': 30,
 'Tea__bird_eye_spot': 31,
 'Tea__brown_blight': 32,
 'Tea__healthy': 33,
 'Tea__red_leaf_spot': 34,
 'Wheat__Healthy': 35,
 'Wheat__brown_rust': 36,
 'Wheat__septoria': 37,
 'Wheat__stripe_rust': 38,
 'Wheat__yellow_rust': 39
 }

Crop_Damage_Categories= {
    'Drought': 0, # Drought damage
    'Good Health': 1, # Good health
    'Weed Damage': 2, # Weed Daamge
}

XceptionArch = tf.keras.applications.xception.Xception(input_shape=(128,128,3),
                                           include_top=False,
                                           weights='imagenet')
Disease_Detection_model=Sequential()
Disease_Detection_model.add(XceptionArch)
Disease_Detection_model.add(GlobalAveragePooling2D())
Disease_Detection_model.add(Flatten())
Disease_Detection_model.add(Dense(1024, activation="relu"))
Disease_Detection_model.add(Dense(512, activation="relu"))
Disease_Detection_model.add(Dense(40, activation="softmax" , name="classification"))

MobileNetModel = tf.keras.applications.MobileNet(weights='imagenet', include_top=False, input_shape=(256, 256, 3)) # 224 224 3
# base_model.trainable = False
Crop_Damage_Classification_Model = Sequential()
Crop_Damage_Classification_Model.add(MobileNetModel)
Crop_Damage_Classification_Model.add(GlobalAveragePooling2D())
Crop_Damage_Classification_Model.add(Flatten())
Crop_Damage_Classification_Model.add(Dense(1024,activation='relu'))
Crop_Damage_Classification_Model.add(Dense(512,activation='relu'))
Crop_Damage_Classification_Model.add(Dense(3, activation="softmax" , name="classification"))

Crop_Recommendation_Model=None

Weed_Detection_Model=None
class MlappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'core.MLApp'
    label='core_MLApp'
    
    def ready(self):
        global Disease_Detection_model
        global Crop_Recommendation_Model
        global Crop_Damage_Classification_Model
        global Weed_Detection_Model
        
        # Get the absolute path to the weights file
        disease_detection_weights_path = os.path.join(os.path.dirname(__file__), 'weights/PlantDiseaseModel.hdf5')
        crop_recommendation_model_path= os.path.join(os.path.dirname(__file__), 'weights/CropRecommendationModel.joblib')
        crop_damage_model_path=os.path.join(os.path.dirname(__file__), 'weights/CropDamageClassificationModel.hdf5')
        weed_detection_model_path=os.path.join(os.path.dirname(__file__),'weights/WeedDetectionModel.pt')
        
        # Load weights to the models
        Weed_Detection_Model=YOLO(weed_detection_model_path)
        Crop_Recommendation_Model=joblib.load(crop_recommendation_model_path)
        Disease_Detection_model.load_weights(disease_detection_weights_path )
        Crop_Damage_Classification_Model.load_weights(crop_damage_model_path)