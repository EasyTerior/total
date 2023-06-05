# common
import os
import sys
import json
import requests
import subprocess
import urllib.parse

# Data Manipuliation
import numpy as np
import pandas as pd

# File I/O
import base64
from io import BytesIO

#DB
from sqlalchemy import create_engine

# image process, model
import cv2
from PIL import Image
from IPython.display import Image, display

# flask
from flask import Flask, request, send_file, send_from_directory, redirect, jsonify
from flask_cors import CORS, cross_origin


# DB - MySQL Connection
engine = create_engine('mysql+pymysql://seocho_0515_2:smhrd2@project-db-stu.smhrd.com:3307/seocho_0515_2?charset=utf8', echo = False)

# buffer = BytesIO()
# img_path = 'D:/total/images/'
# img_file = 'person.jpg' # png -> KeyError: 'P'
# im = Image.open(img_path+img_file)

def readImage():
    member_df = pd.read_sql(sql='SELECT * FROM member', con=engine)
    img_df = pd.read_sql(sql='SELECT * FROM images WHERE', con=engine)

    img_str = img_df['image_data'].values[0]
    # print(type(img_str)) # data type이 'byte'이다.

    img = base64.decodestring(img_str)

    im = Image.open(BytesIO(img))
    im.show()


# Flask
app = Flask(__name__)
print('Hello flask!')
CORS(app)
UPLOAD_FOLDER = 'D:/total/src/main/webapp/resources/images/flask/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

bgr_color=None
selected_items= []
selected_items_labels=[]

@app.route('/process_image', methods=['POST'])
def process_image():
    try:
        # 업로드된 이미지 받기
        image_file = request.files['file']

        # 이미지를 OpenCV로 읽어오기
        image_cv = cv2.imdecode(np.frombuffer(image_file.read(), np.uint8), cv2.IMREAD_COLOR)

        # OpenCV 이미지를 PIL 이미지로 변환
        image_pil = Image.fromarray(cv2.cvtColor(image_cv, cv2.COLOR_BGR2RGB))

        # PIL 이미지를 화면에 표시
        image_pil.show()

        # 객체 탐지 로직 구현
        # TODO: 이미지 처리 및 객체 탐지 코드 작성

        # 결과 반환
        result = {
            'objects': ['object1', 'object2', 'object3'],  # 객체 탐지 결과 리스트 예시
            'confidence': [0.8, 0.6, 0.9]  # 신뢰도 예시
        }
        return jsonify(result), 200

    except Exception as e:
        print("Error processing image:", str(e))
        return jsonify({'error': 'Failed to process image'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

