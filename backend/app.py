# app.py  (Flask example)
import json
import numpy as np
import tensorflow as tf
from flask import Flask, request, jsonify
from keras.preprocessing.image import load_img, img_to_array
from io import BytesIO

app = Flask(__name__)

model = tf.keras.models.load_model('/Users/omarrrefaat/Desktop/AI Connects/finalproject/backend/models/hieromodel/hiero_model.h5', compile=False)
with open('/Users/omarrrefaat/Desktop/AI Connects/finalproject/backend/models/hieromodel/labels.json') as f:
    labels = json.load(f)   # {"0": "ankh", "1": "owl", ...}

@app.route('/predict', methods=['POST'])
def predict():
    file = request.files['file']
    img  = load_img(BytesIO(file.read()), target_size=(224, 224))
    arr  = img_to_array(img) / 255.0
    arr  = np.expand_dims(arr, axis=0)
    preds = model.predict(arr)[0]
    idx   = int(np.argmax(preds))
    return jsonify({'class': labels[str(idx)], 'confidence': float(preds[idx])})

if __name__ == '__main__':
    app.run(debug=True)