# AgriIntel: An AI-Powered Agricultural Assistant

This repository contains the source code for AgriIntel, an AI-powered agricultural assistant designed to assist farmers in optimizing their crop management practices through the power of artificial intelligence and machine learning.

## Features

- **Automated Crop Recommendation:** Suggests the most suitable crops to grow based on soil nutrients, temperature, humidity, rainfall, and other environmental factors.
- **Crop Disease Detection:** Identifies and classifies over 40 different crop diseases by analyzing uploaded images of crop leaves/plants.
- **Crop Damage Detection:** Assesses crop health by detecting drought, weed invasion, or other forms of damage through image analysis.
- **Crop and Weed Object Detection:** Locates and delineates crops and weeds in images, providing bounding boxes and probability scores for each detection.

## Technologies Used

- **Backend:** Django (Python)
- **Frontend:** Flutter (Dart)
- **Machine Learning:** TensorFlow, Keras, YOLOv8
- **Data Sources:** Kaggle datasets for crop recommendation, disease detection, damage classification, and weed detection.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/agriintel.git
   ```
2. Navigate to the project directory:
   ```bash
   cd agriintel
   ```
3. Install the required dependencies for the backend:
   ```bash
   git checkout master
   pip install -r requirements.txt
   ```
4. Install the required dependencies for the frontend:
   ```bash
   git checkout frontend
   flutter pub get
   ```
5. Set up the database and run the Django server:
   ```bash
   git checkout master
   python manage.py migrate
   python manage.py runserver 0.0.0.0:8000
   ```
6. Change the backend address to your backend: go to dataprovider/provider.dart and change the baseUrl to the backend address
   ```bash
   baseUrl: "http://your-backend-address:8000"
   ```
7. Run the Flutter app:
   ```bash
   git checkout frontend
   flutter run
   ```
## Usage

Once the app is running, you can access the various features through the interface. Follow the on-screen instructions to input
relevant information, upload images, and receive intelligent guidance for your crop management needs.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.



